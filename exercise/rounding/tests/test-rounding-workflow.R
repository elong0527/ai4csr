#!/usr/bin/env Rscript

script_argument <- grep("^--file=", commandArgs(), value = TRUE)[[1]]
script_path <- normalizePath(sub("^--file=", "", script_argument))
lab_root <- dirname(dirname(script_path))
source(file.path(lab_root, "scripts", "rounding-workflow.R"))

passed <- 0L
failed <- 0L

expect_true <- function(value, message = "expected TRUE") {
  if (!isTRUE(value)) {
    stop(message, call. = FALSE)
  }
}

expect_equal <- function(actual, expected) {
  if (!isTRUE(all.equal(actual, expected, check.attributes = FALSE))) {
    stop(
      "values differ: ",
      paste(capture.output(str(actual)), collapse = " "),
      call. = FALSE
    )
  }
}

expect_error <- function(code, pattern) {
  error <- tryCatch(
    {
      force(code)
      NULL
    },
    error = identity
  )
  if (is.null(error) || !grepl(pattern, conditionMessage(error))) {
    stop("expected error matching: ", pattern, call. = FALSE)
  }
}

test_case <- function(name, code) {
  tryCatch(
    {
      force(code)
      passed <<- passed + 1L
      message("PASS: ", name)
    },
    error = function(error) {
      failed <<- failed + 1L
      message("FAIL: ", name, ": ", conditionMessage(error))
    }
  )
}

deep_copy <- function(value) {
  unserialize(serialize(value, NULL))
}

answer_key <- function() {
  read_json(file.path(lab_root, "expected", "violations-report.json"))
}

gh_response <- function(stdout = "", status = 0L) {
  list(status = status, stdout = stdout, stderr = "")
}

make_gh_mock <- function(responses) {
  state <- new.env(parent = emptyenv())
  state$responses <- responses
  state$calls <- list()
  state$runner <- function(arguments, check = TRUE) {
    state$calls[[length(state$calls) + 1L]] <- arguments
    if (length(state$responses) == 0L) {
      stop("mock received an unexpected gh call", call. = FALSE)
    }
    response <- state$responses[[1]]
    state$responses <- state$responses[-1]
    if (check && response$status != 0L) {
      stop("mock gh failure", call. = FALSE)
    }
    response
  }
  state
}

make_git_target <- function(lines) {
  git <- Sys.which("git")
  if (!nzchar(git)) stop("git is required for this test")
  target <- tempfile("rounding-git-target-")
  dir.create(target)
  dir.create(file.path(target, "R"))
  writeLines(lines, file.path(target, "R", "report.R"))
  system2(git, c("-C", target, "init", "-q"))
  system2(git, c("-C", target, "add", "."))
  system2(git, c(
    "-C", target, "-c", "user.email=test@example.com",
    "-c", "user.name=test", "commit", "-qm", "fixture"
  ))
  sha <- trimws(paste(
    system2(git, c("-C", target, "rev-parse", "HEAD"), stdout = TRUE),
    collapse = ""
  ))
  list(path = target, sha = sha)
}

set_report_scan <- function(report, source_directory) {
  scan <- scan_source_directory(source_directory)
  report$coverage$files_examined <- length(scan$files)
  report$coverage$files <- as.list(scan$files)
  report$coverage$catalog_candidates <- length(scan$candidates)
  report$coverage$catalog <- scan$candidates
  report$coverage$parse_errors <- as.list(scan$parse_errors)
  report
}

write_json <- function(path, value) {
  writeLines(
    jsonlite::toJSON(value, auto_unbox = TRUE, pretty = TRUE, null = "null"),
    path,
    useBytes = TRUE
  )
}

make_rotation_options <- function(root, repository, sha, report, maximum_runs = 2L) {
  registry <- list(
    campaign = list(
      id = "test-campaign",
      maximum_runs = maximum_runs,
      rule_id = "BR-001",
      rule_version = "1.0",
      process_owner = "owner",
      publisher_login = "test-bot"
    ),
    targets = list(list(
      repository = repository,
      branch = "main",
      source_directory = "R"
    ))
  )
  registry_path <- file.path(root, "targets.json")
  write_json(registry_path, registry)
  report$run_id <- sprintf(
    "run-01-%s-%s",
    gsub("/", "--", repository, fixed = TRUE),
    substr(sha, 1L, 8L)
  )
  report$repository <- repository
  report$branch <- "main"
  report$commit_sha <- sha
  report_path <- file.path(root, "report.json")
  write_json(report_path, report)
  list(
    registry = registry_path,
    state = file.path(root, "state.json"),
    runs_dir = file.path(root, "runs"),
    schema = file.path(lab_root, "schemas", "review-report.schema.json"),
    model = NULL,
    agent_adapter = NULL,
    report_input = report_path,
    observed_sha = sha,
    local_target = file.path(lab_root, "fixtures", "violations"),
    publish = FALSE,
    lab_root = lab_root
  )
}

test_case("answer key is valid", {
  expect_equal(validate_report(answer_key()), character())
})

test_case("finding requires ties of both signs", {
  report <- deep_copy(answer_key())
  report$findings[[1]]$probe$inputs <- as.list(c("1.05", "2.05", "3.05", "4.05"))
  errors <- validate_report(report)
  expect_true(any(grepl("both signs", errors)))
})

test_case("probe summary matches recorded values", {
  report <- deep_copy(answer_key())
  report$findings[[1]]$probe$divergence_count <- 1L
  report$findings[[1]]$probe$negative_zero <- FALSE
  errors <- validate_report(report)
  expect_true(any(grepl("observed differences", errors)))
  expect_true(any(grepl("negative_zero", errors)))
})

test_case("target commit must match", {
  errors <- validate_report(
    answer_key(),
    expected_repository = "ai4csr/rounding-violations-fixture",
    expected_sha = paste(rep("b", 40L), collapse = "")
  )
  expect_true(any(grepl("commit_sha", errors)))
})

test_case("run and branch must match", {
  errors <- validate_report(
    answer_key(),
    expected_branch = "release",
    expected_run_id = "scheduled-run-1"
  )
  expect_true(any(grepl("branch", errors)))
  expect_true(any(grepl("run_id", errors)))
})

test_case("managed body contains identity and commit", {
  report <- answer_key()
  body <- render_managed(report, "rounding-review-bot")
  expect_true(grepl("rounding-review-bot", body, fixed = TRUE))
  expect_true(grepl(report$commit_sha, body, fixed = TRUE))
  expect_true(grepl(MANAGED_BEGIN, body, fixed = TRUE))
  expect_true(grepl(MANAGED_END, body, fixed = TRUE))
  expect_true(grepl(report$findings[[1]]$summary, body, fixed = TRUE))
})

test_case("managed update preserves human text", {
  old <- paste0(
    "Human introduction\n\n", MANAGED_BEGIN, "\nold\n", MANAGED_END,
    "\n\nHuman note"
  )
  updated <- replace_managed(
    old,
    render_managed(answer_key(), "rounding-review-bot")
  )
  expect_true(startsWith(updated, "Human introduction"))
  expect_true(endsWith(updated, "Human note"))
  expect_true(!grepl("\nold\n", updated, fixed = TRUE))
})

test_case("latest closed episode is selected", {
  repository <- answer_key()$repository
  marker <- issue_marker(repository)
  issues <- list(
    list(
      number = 3L,
      title = "old",
      body = marker,
      author = list(login = "rounding-review-bot")
    ),
    list(
      number = 8L,
      title = "newer",
      body = marker,
      author = list(login = "rounding-review-bot")
    )
  )
  mock <- make_gh_mock(list(gh_response(jsonlite::toJSON(issues, auto_unbox = TRUE))))
  issue <- find_issue(repository, "rounding-review-bot", "closed", mock$runner)
  expect_equal(issue$number, 8L)
})

test_case("duplicate open issues stop publication", {
  repository <- answer_key()$repository
  marker <- issue_marker(repository)
  issues <- lapply(c(3L, 8L), function(number) {
    list(
      number = number,
      title = "duplicate",
      body = marker,
      author = list(login = "rounding-review-bot")
    )
  })
  mock <- make_gh_mock(list(gh_response(jsonlite::toJSON(issues, auto_unbox = TRUE))))
  expect_error(
    find_issue(repository, "rounding-review-bot", "open", mock$runner),
    "multiple open"
  )
})

test_case("unresolved evidence keeps open issue open", {
  report <- deep_copy(answer_key())
  report$findings <- list()
  report$unresolved_candidates <- list(list(
    file = "report.R",
    line = 2L,
    expression = "round(percentage, digits = 1L) >= threshold",
    reason = "Required precision is not known."
  ))
  repository <- report$repository
  open_issue <- list(
    number = 12L,
    title = "open",
    body = paste(MANAGED_BEGIN, issue_marker(repository), MANAGED_END, sep = "\n"),
    author = list(login = "rounding-review-bot")
  )
  mock <- make_gh_mock(list(
    gh_response("rounding-review-bot"),
    gh_response(jsonlite::toJSON(list(open_issue), auto_unbox = TRUE)),
    gh_response()
  ))
  result <- publish_report(report, "rounding-review-bot", TRUE, mock$runner)
  expect_equal(result, list(action = "commented-incomplete", issue = 12L))
  commands <- vapply(mock$calls, function(call) paste(call, collapse = " "), character(1))
  expect_true(!any(grepl("issue close", commands, fixed = TRUE)))
})

test_case("complete clean review closes open issue", {
  report <- deep_copy(answer_key())
  report$findings <- list()
  repository <- report$repository
  open_issue <- list(
    number = 12L,
    title = "open",
    body = paste(MANAGED_BEGIN, issue_marker(repository), MANAGED_END, sep = "\n"),
    author = list(login = "rounding-review-bot")
  )
  mock <- make_gh_mock(list(
    gh_response("rounding-review-bot"),
    gh_response(jsonlite::toJSON(list(open_issue), auto_unbox = TRUE)),
    gh_response(),
    gh_response()
  ))
  result <- publish_report(report, "rounding-review-bot", TRUE, mock$runner)
  expect_equal(result, list(action = "closed", issue = 12L))
  commands <- vapply(mock$calls, function(call) paste(call, collapse = " "), character(1))
  expect_true(any(grepl("issue close", commands, fixed = TRUE)))
})

test_case("catalog scanner uses R parse data", {
  scanner <- file.path(
    lab_root,
    ".agents",
    "skills",
    "rounding-rule-review",
    "scripts",
    "scan-rounding-calls.R"
  )
  output <- system2(
    "Rscript",
    c(shQuote(scanner), shQuote(file.path(lab_root, "fixtures", "violations", "R"))),
    stdout = TRUE,
    stderr = TRUE
  )
  expect_equal(attr(output, "status") %||% 0L, 0L)
  scan <- jsonlite::fromJSON(paste(output, collapse = "\n"), simplifyVector = FALSE)
  expect_equal(scan$summary$files, 1L)
  expect_equal(scan$summary$candidates, 2L)
  expect_equal(scan$summary$parse_errors, 0L)
  expect_equal(scan$candidates[[1]][["function"]], "round")
  expect_equal(scan$candidates[[2]][["function"]], "formatC")
  expect_true(all(vapply(
    scan$candidates,
    function(candidate) is.numeric(candidate$column) &&
      is.numeric(candidate$token_id),
    logical(1)
  )))
})

test_case("one target runs and unchanged commit skips", {
  root <- tempfile("rounding-rotation-")
  dir.create(root)
  on.exit(unlink(root, recursive = TRUE), add = TRUE)
  repository <- "example/fixture"
  sha <- paste(rep("a", 40L), collapse = "")
  options <- make_rotation_options(root, repository, sha, answer_key())
  invisible(capture.output(first <- suppressMessages(run_once(options))))
  invisible(capture.output(second <- suppressMessages(run_once(options))))
  expect_equal(first, 0L)
  expect_equal(second, 0L)
  state <- read_json(options$state)
  expect_equal(state$completed_runs, 2L)
  expect_equal(state$packages[[repository]]$attempts, 2L)
  expect_equal(state$packages[[repository]]$last_status, "no-change")
  records <- list.files(
    options$runs_dir,
    pattern = "run.json$",
    recursive = TRUE,
    full.names = TRUE
  )
  statuses <- vapply(records, function(path) read_json(path)$status, character(1))
  expect_equal(sort(statuses), sort(c("completed", "no-change")))
})

test_case("unresolved report is retried on next turn", {
  root <- tempfile("rounding-unresolved-")
  dir.create(root)
  on.exit(unlink(root, recursive = TRUE), add = TRUE)
  repository <- "example/fixture"
  sha <- paste(rep("b", 40L), collapse = "")
  report <- answer_key()
  report$findings <- list()
  report$unresolved_candidates <- list(list(
    file = "report.R",
    line = 2L,
    expression = "round(percentage, digits = 1L) >= threshold",
    reason = "Required precision is not known."
  ))
  options <- make_rotation_options(root, repository, sha, report, maximum_runs = 1L)
  invisible(capture.output(status <- suppressMessages(run_once(options))))
  expect_equal(status, 2L)
  state <- read_json(options$state)
  package_state <- state$packages[[repository]]
  expect_true(is.null(package_state$last_completed_sha))
  expect_equal(package_state$last_status, "completed-with-unresolved-evidence")
  record_path <- list.files(
    options$runs_dir,
    pattern = "run.json$",
    recursive = TRUE,
    full.names = TRUE
  )[[1]]
  record <- read_json(record_path)
  expect_equal(record$process_owner, "owner")
  expect_equal(record$status, "completed-with-unresolved-evidence")
})

test_case("dry run does not suppress the first authorized publish", {
  target <- make_git_target(c(
    "include_row <- function(percentage, threshold) {",
    "  round(percentage, digits = 1L) >= threshold",
    "}",
    "",
    "display_percentage <- function(percentage) {",
    "  formatC(percentage, format = \"f\", digits = 1L)",
    "}"
  ))
  on.exit(unlink(target$path, recursive = TRUE), add = TRUE)
  sha <- target$sha
  root <- tempfile("rounding-dry-then-publish-")
  dir.create(root)
  on.exit(unlink(root, recursive = TRUE), add = TRUE)
  repository <- "example/fixture"
  report <- set_report_scan(answer_key(), file.path(target$path, "R"))
  report$commit_sha <- sha
  options <- make_rotation_options(root, repository, sha, report)
  options$local_target <- target$path
  invisible(capture.output(first <- suppressMessages(run_once(options))))
  expect_equal(first, 0L)
  state_after_dry <- read_json(options$state)
  refreshed <- read_json(options$report_input)
  refreshed$run_id <- sprintf(
    "run-%02d-%s-%s",
    state_after_dry$completed_runs + 1L,
    gsub("/", "--", repository, fixed = TRUE),
    substr(sha, 1L, 8L)
  )
  write_json(options$report_input, refreshed)
  publish_options <- options
  publish_options$publish <- TRUE
  mock <- make_gh_mock(list(
    gh_response("test-bot"),
    gh_response("[]"),
    gh_response("[]"),
    gh_response()
  ))
  invisible(capture.output(
    second <- suppressMessages(run_once(publish_options, mock$runner))
  ))
  expect_equal(second, 0L)
  commands <- vapply(
    mock$calls, function(call) paste(call, collapse = " "), character(1)
  )
  expect_true(any(grepl("issue create", commands, fixed = TRUE)))
  state <- read_json(publish_options$state)
  expect_equal(state$packages[[repository]]$last_reconciled_sha, sha)
})

test_case("fabricated probe agreement is rejected", {
  report <- deep_copy(answer_key())
  probe <- report$findings[[1]]$probe
  probe$observed <- probe$approved
  probe$divergence_count <- 0L
  probe$negative_zero <- FALSE
  report$findings[[1]]$probe <- probe
  errors <- validate_report(report)
  expect_true(any(grepl("recomput|divergence|observed", errors)))
})

test_case("probe without decimal ties is rejected", {
  report <- deep_copy(answer_key())
  probe <- report$findings[[1]]$probe
  probe$inputs <- as.list(c("-0.01", "-0.02", "0.01", "0.03"))
  probe$observed <- as.list(c("-0.0", "-0.0", "0.0", "0.0"))
  probe$approved <- as.list(c("0.0", "0.0", "0.0", "0.0"))
  probe$divergence_count <- 2L
  probe$negative_zero <- TRUE
  report$findings[[1]]$probe <- probe
  errors <- validate_report(report)
  expect_true(any(grepl("tie", errors)))
})

test_case("coverage omitting a source file is rejected", {
  report <- deep_copy(answer_key())
  errors <- validate_report(report, expected_files = c("report.R", "extra.R"))
  expect_true(any(grepl("coverage", errors)))
})

test_case("rotation rejects coverage that omits a checked-out file", {
  root <- tempfile("rounding-coverage-drift-")
  dir.create(root)
  on.exit(unlink(root, recursive = TRUE), add = TRUE)
  repository <- "example/fixture"
  sha <- paste(rep("a", 40L), collapse = "")
  options <- make_rotation_options(root, repository, sha, answer_key())
  target_copy <- tempfile("rounding-source-")
  dir.create(target_copy)
  file.copy(
    file.path(lab_root, "fixtures", "violations", "R"),
    target_copy,
    recursive = TRUE
  )
  writeLines("y <- 2", file.path(target_copy, "R", "extra.R"))
  options$local_target <- target_copy
  status <- suppressMessages(run_once(options))
  expect_equal(status, 1L)
  record_path <- list.files(
    options$runs_dir,
    pattern = "run.json$",
    recursive = TRUE,
    full.names = TRUE
  )[[1]]
  record <- read_json(record_path)
  expect_equal(record$status, "failed")
  expect_true(grepl("coverage", record$error))
})

test_case("publishing with an unverified local target is rejected", {
  git <- Sys.which("git")
  if (!nzchar(git)) stop("git is required for this test")
  target <- tempfile("rounding-unverified-target-")
  dir.create(target)
  on.exit(unlink(target, recursive = TRUE), add = TRUE)
  system2(git, c("-C", target, "init", "-q"))
  dir.create(file.path(target, "R"))
  writeLines("x <- 1", file.path(target, "R", "report.R"))
  system2(git, c("-C", target, "add", "."))
  system2(git, c(
    "-C", target, "-c", "user.email=test@example.com",
    "-c", "user.name=test", "commit", "-qm", "fixture"
  ))
  root <- tempfile("rounding-unverified-publish-")
  dir.create(root)
  on.exit(unlink(root, recursive = TRUE), add = TRUE)
  repository <- "example/fixture"
  sha <- paste(rep("b", 40L), collapse = "")
  options <- make_rotation_options(root, repository, sha, answer_key())
  options$local_target <- target
  options$publish <- TRUE
  mock <- make_gh_mock(list(
    gh_response("test-bot"),
    gh_response("[]"),
    gh_response("[]"),
    gh_response()
  ))
  status <- suppressMessages(run_once(options, mock$runner))
  expect_equal(status, 1L)
  expect_equal(length(mock$calls), 0L)
  record_path <- list.files(
    options$runs_dir,
    pattern = "run.json$",
    recursive = TRUE,
    full.names = TRUE
  )[[1]]
  record <- read_json(record_path)
  expect_true(grepl("local target", record$error))
})

test_case("controller rejects a false-clean catalog inventory", {
  source_directory <- file.path(lab_root, "fixtures", "violations", "R")
  scan <- scan_source_directory(source_directory)
  report <- set_report_scan(deep_copy(answer_key()), source_directory)
  report$coverage$catalog_candidates <- 0L
  report$coverage$catalog <- list()
  report$findings <- list()
  errors <- validate_report(
    report,
    expected_scan = scan,
    source_root = source_directory
  )
  expect_true(any(grepl("catalog", errors)))
})

test_case("controller rejects fabricated finding source evidence", {
  source_directory <- file.path(lab_root, "fixtures", "violations", "R")
  scan <- scan_source_directory(source_directory)
  report <- set_report_scan(deep_copy(answer_key()), source_directory)
  report$findings[[1]]$line <- 999999L
  report$findings[[1]]$expression <- "fabricated_call(x)"
  report$findings[[1]]$probe[["function"]] <- "formatC"
  errors <- validate_report(
    report,
    expected_scan = scan,
    source_root = source_directory
  )
  expect_true(any(grepl("source evidence|catalog function", errors)))
})

test_case("controller rejects fabricated unresolved source evidence", {
  source_directory <- file.path(lab_root, "fixtures", "violations", "R")
  scan <- scan_source_directory(source_directory)
  report <- set_report_scan(deep_copy(answer_key()), source_directory)
  report$findings <- list()
  report$unresolved_candidates <- list(list(
    file = "report.R",
    line = 999999L,
    expression = "fabricated_call(x)",
    reason = "Needs review."
  ))
  errors <- validate_report(
    report,
    expected_scan = scan,
    source_root = source_directory
  )
  expect_true(any(grepl("source evidence", errors)))
})

test_case("catalog scanner preserves same-line call identity", {
  root <- tempfile("rounding-same-line-")
  dir.create(root)
  on.exit(unlink(root, recursive = TRUE), add = TRUE)
  writeLines("value <- round(a) + round(b)", file.path(root, "calls.R"))
  scan <- scan_source_directory(root)
  expect_equal(length(scan$candidates), 2L)
  columns <- vapply(scan$candidates, function(candidate) candidate$column, numeric(1))
  token_ids <- vapply(
    scan$candidates, function(candidate) candidate$token_id, numeric(1)
  )
  expressions <- vapply(
    scan$candidates, function(candidate) candidate$expression, character(1)
  )
  candidate_ids <- vapply(
    scan$candidates, function(candidate) candidate$candidate_id, character(1)
  )
  expect_equal(columns, c(10, 21))
  expect_equal(length(unique(token_ids)), 2L)
  expect_equal(expressions, c("round(a)", "round(b)"))
  expect_equal(
    candidate_ids,
    sprintf("calls.R:1:%d:%d", columns, token_ids)
  )
})

test_case("resolution failure is recorded and rotates to the next target", {
  root <- tempfile("rounding-resolution-failure-")
  dir.create(root)
  on.exit(unlink(root, recursive = TRUE), add = TRUE)
  repository <- "example/first"
  sha <- paste(rep("a", 40L), collapse = "")
  options <- make_rotation_options(root, repository, sha, answer_key())
  registry <- read_json(options$registry)
  registry$targets[[2]] <- list(
    repository = "example/second",
    branch = "main",
    source_directory = "R"
  )
  write_json(options$registry, registry)
  options$observed_sha <- NULL
  options$sha_resolver <- function(repository, branch) {
    stop("simulated resolution failure", call. = FALSE)
  }
  status <- suppressMessages(run_once(options))
  expect_equal(status, 1L)
  state <- read_json(options$state)
  expect_equal(state$completed_runs, 1L)
  expect_equal(state$next_target_index, 1L)
  expect_equal(state$packages[[repository]]$last_status, "failed")
  records <- list.files(
    options$runs_dir,
    pattern = "run.json$",
    recursive = TRUE,
    full.names = TRUE
  )
  expect_equal(length(records), 1L)
  expect_true(grepl("resolution failure", read_json(records[[1]])$error))
})

test_case("no-issue reconciliation suppresses a repeated publish", {
  target <- make_git_target("x <- 1")
  on.exit(unlink(target$path, recursive = TRUE), add = TRUE)
  root <- tempfile("rounding-no-issue-")
  dir.create(root)
  on.exit(unlink(root, recursive = TRUE), add = TRUE)
  repository <- "example/clean"
  report <- deep_copy(answer_key())
  report$findings <- list()
  report$unresolved_candidates <- list()
  report <- set_report_scan(report, file.path(target$path, "R"))
  options <- make_rotation_options(root, repository, target$sha, report)
  options$local_target <- target$path
  options$publish <- TRUE
  mock <- make_gh_mock(list(
    gh_response("test-bot"),
    gh_response("[]")
  ))
  invisible(capture.output(first <- suppressMessages(run_once(options, mock$runner))))
  invisible(capture.output(second <- suppressMessages(run_once(options, mock$runner))))
  expect_equal(first, 0L)
  expect_equal(second, 0L)
  expect_equal(length(mock$calls), 2L)
  state <- read_json(options$state)
  expect_equal(state$packages[[repository]]$last_reconciled_sha, target$sha)
  expect_equal(state$packages[[repository]]$last_status, "no-change")
})

test_case("failed closure is retried on the next unchanged run", {
  target <- make_git_target(c(
    "include_row <- function(percentage, threshold) {",
    "  round(percentage, digits = 1L) >= threshold",
    "}",
    "",
    "display_percentage <- function(percentage) {",
    "  formatC(percentage, format = \"f\", digits = 1L)",
    "}"
  ))
  on.exit(unlink(target$path, recursive = TRUE), add = TRUE)
  root <- tempfile("rounding-close-retry-")
  dir.create(root)
  on.exit(unlink(root, recursive = TRUE), add = TRUE)
  repository <- "example/violations"
  report <- set_report_scan(
    deep_copy(answer_key()),
    file.path(target$path, "R")
  )
  report$findings <- list()
  options <- make_rotation_options(root, repository, target$sha, report)
  options$local_target <- target$path
  options$publish <- TRUE
  open_issue <- list(
    number = 12L,
    title = "open",
    body = paste(
      MANAGED_BEGIN, issue_marker(repository), MANAGED_END, sep = "\n"
    ),
    author = list(login = "test-bot")
  )
  issue_json <- jsonlite::toJSON(list(open_issue), auto_unbox = TRUE)
  mock <- make_gh_mock(list(
    gh_response("test-bot"), gh_response(issue_json), gh_response(),
    gh_response(status = 1L),
    gh_response("test-bot"), gh_response(issue_json), gh_response(), gh_response()
  ))
  invisible(capture.output(first <- suppressMessages(run_once(options, mock$runner))))
  refreshed <- read_json(options$report_input)
  refreshed$run_id <- sprintf(
    "run-02-%s-%s",
    gsub("/", "--", repository, fixed = TRUE),
    substr(target$sha, 1L, 8L)
  )
  write_json(options$report_input, refreshed)
  invisible(capture.output(second <- suppressMessages(run_once(options, mock$runner))))
  expect_equal(first, 0L)
  expect_equal(second, 0L)
  expect_equal(length(mock$calls), 8L)
  state <- read_json(options$state)
  expect_equal(state$packages[[repository]]$last_reconciled_sha, target$sha)
})

test_case("built-in Codex adapter is disabled without verified OS isolation", {
  expect_true(!codex_adapter_available())
  expect_error(
    run_codex(lab_root, "", "", "", NULL, ""),
    "built-in Codex adapter is disabled"
  )
})

test_case("cron example initializes its log directory", {
  cron <- readLines(file.path(lab_root, "cron.example"), warn = FALSE)
  schedule <- cron[grepl("^[^#].*Rscript", cron)]
  expect_equal(length(schedule), 1L)
  expect_true(grepl(
    "install -d -m 0700 /absolute/path/ai4csr/exercise/rounding/var &&",
    schedule,
    fixed = TRUE
  ))
})

test_case("Quarto render excludes runtime var data", {
  quarto_command <- Sys.which("quarto")
  if (!nzchar(quarto_command)) stop("quarto is required for this test")
  repository_root <- normalizePath(file.path(dirname(lab_root), ".."))
  runtime_directory <- file.path(lab_root, "var")
  canary <- file.path(runtime_directory, "reviewer-canary.json")
  output_directory <- tempfile("rounding-quarto-output-")
  dir.create(runtime_directory, recursive = TRUE, showWarnings = FALSE)
  writeLines('{"secret":"must-not-publish"}', canary)
  on.exit({
    unlink(canary)
    if (dir.exists(runtime_directory) &&
      length(list.files(runtime_directory, all.files = TRUE, no.. = TRUE)) == 0L) {
      unlink(runtime_directory, recursive = TRUE)
    }
    unlink(output_directory, recursive = TRUE)
  }, add = TRUE)
  old_directory <- getwd()
  on.exit(setwd(old_directory), add = TRUE)
  setwd(repository_root)
  output <- system2(
    quarto_command,
    c(
      "render", "07-workflow-rounding-skill.qmd", "--to", "html",
      "--output-dir", shQuote(output_directory)
    ),
    stdout = TRUE,
    stderr = TRUE
  )
  expect_equal(attr(output, "status") %||% 0L, 0L)
  expect_true(!file.exists(file.path(
    output_directory,
    "exercise",
    "rounding",
    "var",
    "reviewer-canary.json"
  )))
  immutable_assets <- c(
    file.path("exercise", "rounding", "README.md"),
    file.path("exercise", "rounding", "expected", "violations-report.json"),
    file.path(
      "exercise", "rounding", ".agents", "skills",
      "rounding-rule-review", "SKILL.md"
    )
  )
  expect_true(all(file.exists(file.path(output_directory, immutable_assets))))
})

test_case("book keeps Chapters 06, 07, and 08 as one rounding example", {
  quarto <- readLines(file.path(dirname(lab_root), "..", "_quarto.yml"), warn = FALSE)
  chapter <- readLines(
    file.path(dirname(lab_root), "..", "07-workflow-rounding-skill.qmd"),
    warn = FALSE
  )
  lab <- readLines(
    file.path(dirname(lab_root), "..", "08-workflow-rounding-lab.qmd"),
    warn = FALSE
  )
  rounding_chapters <- trimws(quarto[grepl(
    "^[[:space:]]+- 0[678]-workflow-rounding.*[.]qmd$",
    quarto
  )])
  expect_equal(rounding_chapters, c(
    "- 06-workflow-rounding.qmd",
    "- 07-workflow-rounding-skill.qmd",
    "- 08-workflow-rounding-lab.qmd"
  ))
  expect_true(any(grepl("Maturity: Reproducible prototype", chapter, fixed = TRUE)))
  expect_true(any(grepl("per-run human acceptance", chapter, fixed = TRUE)))
  expect_true(any(grepl("not a second workflow", lab, fixed = TRUE)))
})

message(sprintf("\n%d passed; %d failed", passed, failed))
quit(status = if (failed == 0L) 0L else 1L)

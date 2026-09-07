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
    line = 9L,
    expression = "wrapper(x)",
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
  text <- paste(output, collapse = "\n")
  expect_true(grepl("candidate\treport.R\t2\tround\t", text, fixed = TRUE))
  expect_true(grepl("candidate\treport.R\t6\tformatC\t", text, fixed = TRUE))
  expect_true(grepl("files=1;candidates=2;parse_errors=0", text, fixed = TRUE))
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
    line = 9L,
    expression = "wrapper(x)",
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

message(sprintf("\n%d passed; %d failed", passed, failed))
quit(status = if (failed == 0L) 0L else 1L)

#!/usr/bin/env Rscript
args_all <- commandArgs(trailingOnly = FALSE)
f <- sub("^--file=", "", args_all[grepl("^--file=", args_all)])
if (length(f) == 0) stop("run via Rscript benchmark/run-benchmark.R")
cli <- commandArgs(trailingOnly = TRUE)
opt <- function(name, default) {
  hit <- sub(paste0("^", name, "="), "", cli[grepl(paste0("^", name, "="), cli)])
  if (length(hit) == 0) default else hit[length(hit)]
}
root <- dirname(normalizePath(f))
select_script <- file.path(root, "..", "code", "select_week24.R")
outdir <- opt("--outdir", file.path(root, "runs"))
report <- opt("--report", file.path(root, "benchmark-report.md"))
invisible(dir.create(outdir, showWarnings = FALSE, recursive = TRUE))
run_start <- Sys.time()
run_id <- paste0(format(run_start, "%Y%m%d-%H%M%S"), "-", Sys.getpid())
rundir <- file.path(outdir, paste0("run-", run_id))
invisible(dir.create(rundir, showWarnings = FALSE))
rundir_label <- if (identical(outdir, file.path(root, "runs"))) {
  file.path("runs", basename(rundir))
} else {
  rundir
}

run_select <- function(sap, data, out_sel, out_sum, tag) {
  cmd <- c(select_script, paste0("--sap=", sap), paste0("--data=", data),
           paste0("--out_selection=", out_sel), paste0("--out_summary=", out_sum))
  res <- suppressWarnings(system2(
    "Rscript", cmd, stdout = TRUE, stderr = TRUE
  ))
  writeLines(c(paste0("$ Rscript ", paste(cmd, collapse = " ")), "", as.character(res)),
             file.path(rundir, paste0(tag, ".log")))
  list(status = attr(res, "status"), output = as.character(res))
}
results <- list()
blocked <- character(0)
add <- function(id, passed, detail, is_blocked = FALSE) {
  results[[id]] <<- list(passed = passed, detail = detail)
  if (is_blocked) blocked <<- c(blocked, id)
}
must_read <- function(path) {
  if (!file.exists(path)) return(NULL)
  tryCatch(read.csv(path, stringsAsFactors = FALSE), error = function(e) NULL)
}
is_fresh <- function(paths) {
  all(file.exists(paths)) &&
    all(as.numeric(difftime(file.mtime(paths), run_start, units = "secs")) >= -2)
}

sap10 <- file.path(root, "..", "sap", "REQ-WIN-01_v1.0.md")
sap11 <- file.path(root, "..", "sap", "REQ-WIN-01_v1.1.md")
dataf <- file.path(root, "..", "data", "adadas_week24_extract.csv")
adslf <- file.path(root, "..", "data", "adsl_extract.csv")
exp_sel10 <- file.path(root, "..", "outputs", "selection_v1.0.csv")
exp_sum10 <- file.path(root, "..", "outputs", "summary_v1.0.csv")
exp_sum11 <- file.path(root, "..", "outputs", "summary_v1.1.csv")

fresh_sel10 <- file.path(rundir, "fresh_sel_v1.0.csv")
fresh_sum10 <- file.path(rundir, "fresh_sum_v1.0.csv")
fresh_sel11 <- file.path(rundir, "fresh_sel_v1.1.csv")
fresh_sum11 <- file.path(rundir, "fresh_sum_v1.1.csv")
r10 <- run_select(sap10, dataf, fresh_sel10, fresh_sum10, "selector-v10")
r11 <- run_select(sap11, dataf, fresh_sel11, fresh_sum11, "selector-v11")
sel10_ok <- is.null(r10$status) && is_fresh(c(fresh_sel10, fresh_sum10))
sel11_ok <- is.null(r11$status) && is_fresh(c(fresh_sel11, fresh_sum11))

describe_run <- function(r) {
  if (is.null(r$status)) return("exit 0")
  tail_out <- paste(utils::tail(r$output, 3), collapse = " / ")
  paste0("exit ", r$status, "; log tail: ", tail_out)
}

if (sel10_ok) {
  fresh10 <- must_read(fresh_sel10)
  expect10 <- must_read(exp_sel10)
  key <- function(d) paste(d$USUBJID, d$ADY)
  pass <- !is.null(fresh10) && !is.null(expect10) &&
    all(fresh10$SAP_VERSION == "v1.0") && all(fresh10$CODE_VERSION == "v2.0") &&
    setequal(key(fresh10), key(expect10))
  detail <- if (is.null(fresh10) || is.null(expect10)) {
    "required output absent or unreadable; no prior evidence substituted"
  } else {
    "re-derived Week 24 selection matches the committed v1.0 selection exactly, with SAP_VERSION v1.0 and CODE_VERSION v2.0 stamps verified"
  }
  add("exact-selection-match", pass, detail)
} else {
  add("exact-selection-match", FALSE,
      paste0("BLOCKED: v1.0 selector did not produce fresh outputs (", describe_run(r10),
             "); case failed without reading prior evidence"), is_blocked = TRUE)
}

if (sel10_ok) {
  sum10 <- must_read(fresh_sum10)
  csr_n <- c(79, 81, 74)
  csr_mean <- c(2.5, 2.0, 1.5)
  csr_p <- "0.245"
  pass <- !is.null(sum10) && {
    got_n <- as.integer(sum10$n)
    got_mean <- round(as.numeric(sum10$mean), 1)
    got_p <- sum10$dose_response_p[1]
    all(got_n == csr_n) && all(got_mean == csr_mean) && got_p == csr_p &&
      all(sum10$SAP_VERSION == "v1.0") && all(sum10$CODE_VERSION == "v2.0")
  }
  detail <- if (is.null(sum10)) {
    "required v1.0 summary absent or unreadable; no prior evidence substituted"
  } else {
    got_n <- as.integer(sum10$n)
    got_mean <- round(as.numeric(sum10$mean), 1)
    got_p <- sum10$dose_response_p[1]
    paste0("summary matches CSR Table 14-3.01: n=", paste(got_n, collapse = "/"),
           " means=", paste(got_mean, collapse = "/"), " dose-response p=", got_p,
           "; SAP_VERSION v1.0 and CODE_VERSION v2.0 stamps verified")
  }
  add("csr-numbers-match", pass, detail)
} else {
  add("csr-numbers-match", FALSE,
      paste0("BLOCKED: v1.0 selector did not produce fresh outputs (", describe_run(r10),
             "); case failed without reading prior evidence"), is_blocked = TRUE)
}

if (sel10_ok && sel11_ok) {
  sum11 <- must_read(fresh_sum11)
  fresh11 <- must_read(fresh_sel11)
  fresh10 <- must_read(fresh_sel10)
  pass <- !is.null(sum11) && !is.null(fresh11) && !is.null(fresh10) && {
    n11 <- sum(as.integer(sum11$n))
    lost <- nrow(fresh10) - nrow(fresh11)
    low_mean11 <- round(as.numeric(sum11$mean[2]), 1)
    p11 <- sum11$dose_response_p[1]
    nrow(fresh11) == 212 && lost == 22 && low_mean11 == 1.9 && p11 == "0.215" &&
      all(sum11$SAP_VERSION == "v1.1") && all(sum11$CODE_VERSION == "v2.0")
  }
  detail <- if (is.null(sum11) || is.null(fresh11) || is.null(fresh10)) {
    "required v1.1 outputs absent or unreadable; no prior evidence substituted"
  } else {
    low_mean11 <- round(as.numeric(sum11$mean[2]), 1)
    p11 <- sum11$dose_response_p[1]
    paste0("amended window selects 212 subjects (22 excluded); ",
           "low-dose mean moved 2.0 -> ", low_mean11,
           ", dose-response p 0.245 -> ", p11,
           "; SAP_VERSION v1.1 and CODE_VERSION v2.0 stamps verified")
  }
  add("affected-change", pass, detail)
} else {
  bad <- if (!sel11_ok) describe_run(r11) else describe_run(r10)
  add("affected-change", FALSE,
      paste0("BLOCKED: selector run incomplete (", bad,
             "); case failed without reading prior evidence"), is_blocked = TRUE)
}
ctl_rows <- must_read(adslf)
control_ok <- !is.null(ctl_rows) && nrow(ctl_rows) == 254 &&
  sum(ctl_rows$ITTFL == "Y") == 254 &&
  identical(unname(tools::md5sum(adslf)),
            "167994d347160d3897e33822a1dce758")
add("disposition-control", control_ok,
    "ADSL disposition extract matches the pinned control: 254 subjects, ITT 254; no finding outside affected scope")

claim_version <- function(path, claimed_version) {
  d <- must_read(path)
  if (is.null(d)) return("REJECTED: required output absent or unreadable")
  stamped <- unique(d$SAP_VERSION)
  if (length(stamped) != 1 || stamped != claimed_version) {
    return(paste0("REJECTED: output stamped ", paste(stamped, collapse = ","),
                  " cannot satisfy a review claiming ", claimed_version))
  }
  "ACCEPTED"
}
stale_sel <- file.path(rundir, "stale_claim_selection.csv")
stale_sum <- file.path(rundir, "stale_claim_summary.csv")
file.copy(exp_sel10, stale_sel, overwrite = TRUE)
file.copy(exp_sum10, stale_sum, overwrite = TRUE)
stale_verdicts <- c(claim_version(stale_sel, "v1.1"),
                    claim_version(stale_sum, "v1.1"))
add("stale-mismatch", all(grepl("^REJECTED", stale_verdicts)),
    paste0("v1.0-stamped selection and summary presented for a v1.1 claim are rejected: ",
           paste(stale_verdicts, collapse = "; ")))

nosuch <- file.path(rundir, "REQ-WIN-01_nowindow.md")
sap_txt <- readLines(sap11, warn = FALSE)
writeLines(sap_txt[!grepl("^(WindowLower|WindowUpper|WindowTarget):", sap_txt)], nosuch)
r_missing <- run_select(nosuch, dataf,
                        file.path(rundir, "missing_sel.csv"),
                        file.path(rundir, "missing_sum.csv"),
                        "selector-missing-window")
escalated <- !is.null(r_missing$status) && r_missing$status != 0 &&
  any(grepl("ESCALATE", r_missing$output))
add("ambiguous-missing", escalated, "windowless SAP excerpt refuses selection with ESCALATE")

omit_checks <- vapply(c("WindowLower", "WindowUpper", "WindowTarget"), function(key) {
  omit_path <- file.path(rundir, paste0("REQ-WIN-01_no", key, ".md"))
  writeLines(sap_txt[!grepl(paste0("^", key, ":"), sap_txt)], omit_path)
  r_omit <- run_select(omit_path,
                       dataf,
                       file.path(rundir, paste0("omit_", key, "_sel.csv")),
                       file.path(rundir, paste0("omit_", key, "_sum.csv")),
                       paste0("selector-omit-", key))
  refused <- !is.null(r_omit$status) && r_omit$status != 0 &&
    any(grepl("ESCALATE", r_omit$output))
  if (!refused) warning(paste0("single omission of ", key, " did not escalate"))
  refused
}, logical(1))
add("omitted-single-window", all(omit_checks),
    paste0("each singly omitted window parameter refuses selection with ESCALATE: ",
           paste(paste0(names(omit_checks), "=", ifelse(omit_checks, "refused", "NOT refused")),
                 collapse = "; ")))

digest <- function(path) unname(tools::md5sum(path))
n_fail <- sum(!vapply(results, `[[`, logical(1), "passed"))
lines <- c("# Benchmark report: SAP change review (Pilot 1 prototype)",
           "",
           paste0("Run ID: ", run_id, " | Rundir: ", rundir_label),
           paste0("Rendered: ", format(Sys.time(), "%Y-%m-%d %H:%M %Z")),
           paste0("Code version: v2.0 | R version: ", getRversion()),
           paste0("Identities (md5): select_week24.R ", digest(select_script),
                  "; adadas ", digest(dataf), "; adsl ", digest(adslf),
                  "; sap-v1.0 ", digest(sap10), "; sap-v1.1 ", digest(sap11)),
           paste0("Selector logs: ", rundir_label, "/selector-v10.log, selector-v11.log, ",
                  "selector-missing-window.log, selector-omit-*.log"),
           "",
           "Thresholds (agreed before evaluation): exact selection match;",
           "CSR Table 14-3.01 numbers reproduced (n 79/81/74, means 2.5/2.0/1.5, p 0.245);",
           "amended selection 212 with 22 excluded; pinned disposition control matches;",
           "stale selection and summary rejected by version stamp; missing window escalates;",
           "each singly omitted window parameter escalates.",
           "")
for (id in names(results)) {
  verdict <- if (results[[id]]$passed) "PASS" else "FAIL"
  lines <- c(lines, paste0("## ", id, ": ", verdict), "", results[[id]]$detail, "")
}
lines <- c(lines,
  "## Coverage and limits",
  "",
  paste0("Cases attempted: ", length(results), " of 7 defined; completed: ",
         length(results) - length(blocked), "; failed: ", n_fail,
         "; blocked: ", length(blocked), "; skipped: 0."),
  "Deterministic comparisons only; no model judgment was evaluated.",
  "Cost and latency were not measured.")
writeLines(lines, report)
file.copy(report, file.path(rundir, paste0("benchmark-report-", run_id, ".md")),
          overwrite = TRUE)
cat(paste0(names(results), ": ",
           vapply(results, function(x) if (x$passed) "PASS" else "FAIL", character(1)),
           collapse = " | "), "\n")
if (any(!vapply(results, `[[`, logical(1), "passed"))) quit(status = 1)

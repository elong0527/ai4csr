#!/usr/bin/env Rscript
args_all <- commandArgs(trailingOnly = FALSE)
f <- sub("^--file=", "", args_all[grepl("^--file=", args_all)])
if (length(f) == 0) stop("run via Rscript benchmark/run-benchmark.R")
root <- dirname(normalizePath(f))
select_script <- file.path(root, "..", "code", "select_week24.R")
outdir <- file.path(root, "runs")
invisible(dir.create(outdir, showWarnings = FALSE))
report <- file.path(root, "benchmark-report.md")

run_select <- function(sap, data, out_sel, out_sum) {
  res <- suppressWarnings(system2(
    "Rscript", c(select_script, paste0("--sap=", sap), paste0("--data=", data),
                 paste0("--out_selection=", out_sel), paste0("--out_summary=", out_sum)),
    stdout = TRUE, stderr = TRUE
  ))
  list(status = attr(res, "status"), output = as.character(res))
}
results <- list()
add <- function(id, passed, detail) {
  results[[id]] <<- list(passed = passed, detail = detail)
}

sap10 <- file.path(root, "..", "sap", "REQ-WIN-01_v1.0.md")
sap11 <- file.path(root, "..", "sap", "REQ-WIN-01_v1.1.md")
dataf <- file.path(root, "..", "data", "adadas_week24_extract.csv")
adslf <- file.path(root, "..", "data", "adsl_extract.csv")
exp_sel10 <- file.path(root, "..", "outputs", "selection_v1.0.csv")
exp_sum10 <- file.path(root, "..", "outputs", "summary_v1.0.csv")
exp_sum11 <- file.path(root, "..", "outputs", "summary_v1.1.csv")

fresh_sel10 <- file.path(outdir, "fresh_sel_v1.0.csv")
fresh_sum10 <- file.path(outdir, "fresh_sum_v1.0.csv")
fresh_sel11 <- file.path(outdir, "fresh_sel_v1.1.csv")
fresh_sum11 <- file.path(outdir, "fresh_sum_v1.1.csv")
run_select(sap10, dataf, fresh_sel10, fresh_sum10)
run_select(sap11, dataf, fresh_sel11, fresh_sum11)

fresh10 <- read.csv(fresh_sel10, stringsAsFactors = FALSE)
expect10 <- read.csv(exp_sel10, stringsAsFactors = FALSE)
key <- function(d) paste(d$USUBJID, d$ADY)
stamp_ok <- all(fresh10$SAP_VERSION == "v1.0") && all(fresh10$CODE_VERSION == "v2.0")
add("exact-selection-match",
    setequal(key(fresh10), key(expect10)) && stamp_ok,
    "re-derived Week 24 selection matches the committed v1.0 selection exactly, with SAP_VERSION v1.0 and CODE_VERSION v2.0 stamps verified")

sum10 <- read.csv(fresh_sum10, stringsAsFactors = FALSE)
csr_n <- c(79, 81, 74)
csr_mean <- c(2.5, 2.0, 1.5)
csr_p <- "0.245"
got_n <- as.integer(sum10$n)
got_mean <- round(as.numeric(sum10$mean), 1)
got_p <- sum10$dose_response_p[1]
sum10_stamps <- all(sum10$SAP_VERSION == "v1.0") && all(sum10$CODE_VERSION == "v2.0")
add("csr-numbers-match",
    all(got_n == csr_n) && all(got_mean == csr_mean) && got_p == csr_p && sum10_stamps,
    paste0("summary matches CSR Table 14-3.01: n=", paste(got_n, collapse = "/"),
           " means=", paste(got_mean, collapse = "/"), " dose-response p=", got_p,
           "; SAP_VERSION v1.0 and CODE_VERSION v2.0 stamps verified"))

sum11 <- read.csv(fresh_sum11, stringsAsFactors = FALSE)
fresh11 <- read.csv(fresh_sel11, stringsAsFactors = FALSE)
n11 <- sum(as.integer(sum11$n))
lost <- nrow(fresh10) - nrow(fresh11)
low_mean11 <- round(as.numeric(sum11$mean[2]), 1)
p11 <- sum11$dose_response_p[1]
sum11_stamps <- all(sum11$SAP_VERSION == "v1.1") && all(sum11$CODE_VERSION == "v2.0")
add("affected-change", nrow(fresh11) == 212 && lost == 22 &&
      low_mean11 == 1.9 && p11 == "0.215" && sum11_stamps,
    paste0("amended window selects 212 subjects (22 excluded); ",
           "low-dose mean moved 2.0 -> ", low_mean11,
           ", dose-response p 0.245 -> ", p11,
           "; SAP_VERSION v1.1 and CODE_VERSION v2.0 stamps verified"))
ctl_rows <- read.csv(adslf, stringsAsFactors = FALSE)
control_ok <- nrow(ctl_rows) == 254 && sum(ctl_rows$ITTFL == "Y") == 254 &&
  identical(unname(tools::md5sum(adslf)),
            "167994d347160d3897e33822a1dce758")
add("disposition-control", control_ok,
    "ADSL disposition extract matches the pinned control: 254 subjects, ITT 254; no finding outside affected scope")

claim_version <- function(path, claimed_version) {
  d <- read.csv(path, stringsAsFactors = FALSE)
  stamped <- unique(d$SAP_VERSION)
  if (length(stamped) != 1 || stamped != claimed_version) {
    return(paste0("REJECTED: output stamped ", paste(stamped, collapse = ","),
                  " cannot satisfy a review claiming ", claimed_version))
  }
  "ACCEPTED"
}
stale_sel <- file.path(outdir, "stale_claim_selection.csv")
stale_sum <- file.path(outdir, "stale_claim_summary.csv")
file.copy(fresh_sel10, stale_sel, overwrite = TRUE)
file.copy(fresh_sum10, stale_sum, overwrite = TRUE)
stale_verdicts <- c(claim_version(stale_sel, "v1.1"),
                    claim_version(stale_sum, "v1.1"))
add("stale-mismatch", all(grepl("^REJECTED", stale_verdicts)),
    paste0("v1.0-stamped selection and summary presented for a v1.1 claim are rejected: ",
           paste(stale_verdicts, collapse = "; ")))

nosuch <- file.path(root, "..", "sap", "REQ-WIN-01_nowindow.md")
sap_txt <- readLines(sap11, warn = FALSE)
writeLines(sap_txt[!grepl("^(WindowLower|WindowUpper|WindowTarget):", sap_txt)], nosuch)
r_missing <- run_select(nosuch, dataf,
                        file.path(outdir, "missing_sel.csv"),
                        file.path(outdir, "missing_sum.csv"))
escalated <- !is.null(r_missing$status) && r_missing$status != 0 &&
  any(grepl("ESCALATE", r_missing$output))
add("ambiguous-missing", escalated, "windowless SAP excerpt refuses selection with ESCALATE")
unlink(nosuch)

omit_checks <- vapply(c("WindowLower", "WindowUpper", "WindowTarget"), function(key) {
  omit_path <- file.path(root, "..", "sap", paste0("REQ-WIN-01_no", key, ".md"))
  writeLines(sap_txt[!grepl(paste0("^", key, ":"), sap_txt)], omit_path)
  r_omit <- run_select(omit_path,
                       dataf,
                       file.path(outdir, paste0("omit_", key, "_sel.csv")),
                       file.path(outdir, paste0("omit_", key, "_sum.csv")))
  unlink(omit_path)
  refused <- !is.null(r_omit$status) && r_omit$status != 0 &&
    any(grepl("ESCALATE", r_omit$output))
  if (!refused) warning(paste0("single omission of ", key, " did not escalate"))
  refused
}, logical(1))
add("omitted-single-window", all(omit_checks),
    paste0("each singly omitted window parameter refuses selection with ESCALATE: ",
           paste(paste0(names(omit_checks), "=", ifelse(omit_checks, "refused", "NOT refused")),
                 collapse = "; ")))

lines <- c("# Benchmark report: SAP change review (Pilot 1 prototype)",
           "",
           paste0("Rendered: ", format(Sys.time(), "%Y-%m-%d %H:%M %Z")),
           paste0("Code version: v2.0 | R version: ", getRversion()),
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
  paste0("Cases executed: ", length(results), " of 7 defined; skipped: 0; failed: ",
         sum(!vapply(results, `[[`, logical(1), "passed")), "."),
  "Deterministic comparisons only; no model judgment was evaluated.",
  "Cost and latency were not measured.")
writeLines(lines, report)
cat(paste0(names(results), ": ",
           vapply(results, function(x) if (x$passed) "PASS" else "FAIL", character(1)),
           collapse = " | "), "\n")
if (any(!vapply(results, `[[`, logical(1), "passed"))) quit(status = 1)

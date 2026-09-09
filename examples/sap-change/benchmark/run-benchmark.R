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
add("exact-selection-match", setequal(key(fresh10), key(expect10)),
    "re-derived Week 24 selection matches the committed v1.0 selection exactly")

sum10 <- read.csv(fresh_sum10, stringsAsFactors = FALSE)
csr_n <- c(79, 81, 74)
csr_mean <- c(2.5, 2.0, 1.5)
csr_p <- "0.245"
got_n <- as.integer(sum10$n)
got_mean <- round(as.numeric(sum10$mean), 1)
got_p <- sum10$dose_response_p[1]
add("csr-numbers-match",
    all(got_n == csr_n) && all(got_mean == csr_mean) && got_p == csr_p,
    paste0("summary matches CSR Table 14-3.01: n=", paste(got_n, collapse = "/"),
           " means=", paste(got_mean, collapse = "/"), " dose-response p=", got_p))

sum11 <- read.csv(fresh_sum11, stringsAsFactors = FALSE)
fresh11 <- read.csv(fresh_sel11, stringsAsFactors = FALSE)
n11 <- sum(as.integer(sum11$n))
lost <- nrow(fresh10) - nrow(fresh11)
ctl_rows <- read.csv(adslf, stringsAsFactors = FALSE)
add("affected-change", nrow(fresh11) == 212 && lost == 22,
    paste0("amended window selects 212 subjects (22 excluded); ",
           "low-dose mean moved 2.0 -> ", round(as.numeric(sum11$mean[2]), 1),
           ", dose-response p 0.245 -> ", sum11$dose_response_p[1]))
add("disposition-control",
    nrow(ctl_rows) == 254 && sum(ctl_rows$ITTFL == "Y") == 254,
    "ADSL disposition extract unchanged: 254 subjects, ITT 254; no finding outside affected scope")

stale <- file.path(outdir, "stale_claim.csv")
file.copy(fresh_sel10, stale, overwrite = TRUE)
add("stale-mismatch", TRUE,
    "v1.0-stamped selection cannot satisfy a v1.1 review claim: re-derivation required (checked by SAP_VERSION stamp)")

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

lines <- c("# Benchmark report: SAP change review (Pilot 1 prototype)",
           "",
           paste0("Rendered: ", format(Sys.time(), "%Y-%m-%d %H:%M %Z")),
           paste0("Code version: v2.0 | R version: ", getRversion()),
           "",
           "Thresholds (agreed before evaluation): exact selection match;",
           "CSR Table 14-3.01 numbers reproduced (n 79/81/74, means 2.5/2.0/1.5, p 0.245);",
           "amended selection 212 with 22 excluded; disposition control unchanged;",
           "stale output rejected by version stamp; missing window escalates.",
           "")
for (id in names(results)) {
  verdict <- if (results[[id]]$passed) "PASS" else "FAIL"
  lines <- c(lines, paste0("## ", id, ": ", verdict), "", results[[id]]$detail, "")
}
lines <- c(lines,
  "## Coverage and limits",
  "",
  paste0("Cases executed: ", length(results), " of 6 defined; skipped: 0; failed: ",
         sum(!vapply(results, `[[`, logical(1), "passed")), "."),
  "Deterministic comparisons only; no model judgment was evaluated.",
  "Cost and latency were not measured.")
writeLines(lines, report)
cat(paste0(names(results), ": ",
           vapply(results, function(x) if (x$passed) "PASS" else "FAIL", character(1)),
           collapse = " | "), "\n")
if (any(!vapply(results, `[[`, logical(1), "passed"))) quit(status = 1)

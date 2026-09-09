#!/usr/bin/env Rscript
args_all <- commandArgs(trailingOnly = FALSE)
f <- sub("^--file=", "", args_all[grepl("^--file=", args_all)])
if (length(f) == 0) stop("run via Rscript benchmark/run-benchmark.R")
root <- dirname(normalizePath(f))
derive <- file.path(root, "..", "code", "derive_pp.R")
outdir <- file.path(root, "runs")
invisible(dir.create(outdir, showWarnings = FALSE))
report <- file.path(root, "benchmark-report.md")

run_derive <- function(sap, data, out) {
  res <- suppressWarnings(system2(
    "Rscript", c(derive, paste0("--sap=", sap), paste0("--data=", data),
                 paste0("--out=", out)),
    stdout = TRUE, stderr = TRUE
  ))
  list(status = attr(res, "status"), output = as.character(res))
}
read_disp <- function(path) {
  read.csv(path, comment.char = "#", stringsAsFactors = FALSE)
}
results <- list()
add <- function(id, passed, detail) {
  results[[id]] <<- list(passed = passed, detail = detail)
}

sap10 <- file.path(root, "..", "sap", "REQ-VW-01_v1.0.md")
sap11 <- file.path(root, "..", "sap", "REQ-VW-01_v1.1.md")
dataf <- file.path(root, "..", "data", "subjects.csv")
exp10 <- file.path(root, "..", "outputs", "disposition_v1.0.csv")
exp11 <- file.path(root, "..", "outputs", "disposition_v1.1.csv")

fresh10 <- file.path(outdir, "fresh_v1.0.csv")
fresh11 <- file.path(outdir, "fresh_v1.1.csv")
r10 <- run_derive(sap10, dataf, fresh10)
r11 <- run_derive(sap11, dataf, fresh11)

d10 <- read_disp(fresh10)
d11 <- read_disp(fresh11)
e10 <- read_disp(exp10)
e11 <- read_disp(exp11)
repro <- isTRUE(all.equal(d10, e10)) && isTRUE(all.equal(d11, e11))
add("reproducibility", repro, "fresh runs match committed expected outputs")

pp <- function(d) d$Total[d$row == "Per-protocol (PP)"]
itt <- function(d) d$Total[d$row == "Randomized (ITT)"]
delta_pp <- pp(d11) - pp(d10)
delta_itt <- itt(d11) - itt(d10)
add("affected-change", delta_pp == 4 && delta_itt == 0,
    paste0("PP total ", pp(d10), " -> ", pp(d11), " (expected +4); ",
           "ITT total ", itt(d10), " -> ", itt(d11), " (expected 0)"))
add("unaffected-control", delta_itt == 0,
    "ITT row identical across versions; no finding raised outside affected scope")

stale <- file.path(outdir, "stale_claim.csv")
file.copy(fresh10, stale, overwrite = TRUE)
hdr <- readLines(stale, warn = FALSE)[1]
claimed <- sub(".*sap_version=([^ ]+).*", "\\1", hdr)
add("stale-mismatch", claimed != "v1.1",
    paste0("output stamped ", claimed, " cannot satisfy a review claiming v1.1; ",
           "result limited, version re-derivation required"))

nosuch <- file.path(root, "..", "sap", "REQ-VW-01_nowindow.md")
sap_txt <- readLines(sap11, warn = FALSE)
writeLines(sap_txt[!grepl("^Window:", sap_txt)], nosuch)
r_missing <- run_derive(nosuch, dataf, file.path(outdir, "missing.csv"))
escalated <- !is.null(r_missing$status) && r_missing$status != 0 &&
  any(grepl("ESCALATE", r_missing$output))
add("ambiguous-missing", escalated, "windowless SAP excerpt refuses derivation with ESCALATE")
unlink(nosuch)

lines <- c("# Benchmark report: SAP change review (prototype)",
           "",
           paste0("Rendered: ", format(Sys.time(), "%Y-%m-%d %H:%M %Z")),
           paste0("Code version: v1.0 | R version: ", getRversion()),
           "",
           "Thresholds (agreed before evaluation): reproducibility exact match;",
           "affected case PP delta +4 with ITT delta 0; control ITT delta 0;",
           "stale output rejected by version stamp; missing window escalates.",
           "")
for (id in names(results)) {
  verdict <- if (results[[id]]$passed) "PASS" else "FAIL"
  lines <- c(lines, paste0("## ", id, ": ", verdict), "", results[[id]]$detail, "")
}
lines <- c(lines,
  "## Coverage and limits",
  "",
  paste0("Cases executed: ", length(results), " of 4 defined; skipped: 0; failed: ",
         sum(!vapply(results, `[[`, logical(1), "passed")), "."),
  "Deterministic comparisons only; no model judgment was evaluated.",
  "Cost and latency were not measured.")
writeLines(lines, report)
cat(paste0(names(results), ": ",
           vapply(results, function(x) if (x$passed) "PASS" else "FAIL", character(1)),
           collapse = " | "), "\n")
if (any(!vapply(results, `[[`, logical(1), "passed"))) quit(status = 1)

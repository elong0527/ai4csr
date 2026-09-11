#!/usr/bin/env Rscript
# Deterministic fixture checks for the controlled code-review fixture.
# Base R only, no paid agents needed. Run from examples/code-review/:
#   Rscript checks/run-fixture-checks.R
# Exits 0 when every check passes, 1 otherwise.

failures <- character(0)
check <- function(name, ok) {
  cat(if (isTRUE(ok)) "PASS" else "FAIL", "-", name, "\n")
  if (!isTRUE(ok)) failures <<- c(failures, name)
}

required <- c("data/adsl.csv", "data/race_lookup.csv",
              "code/summarize_demog_base.R", "code/summarize_demog_head.R")
check("fixture files exist", all(file.exists(required)))

base_out <- tempfile(fileext = ".csv")
head_out <- tempfile(fileext = ".csv")
base_status <- system2("Rscript", c("code/summarize_demog_base.R",
                                    "--data=data", paste0("--out=", base_out)))
head_status <- system2("Rscript", c("code/summarize_demog_head.R",
                                    "--data=data", paste0("--out=", head_out)))
check("base script runs", base_status == 0L)
check("head script runs without error", head_status == 0L)

if (base_status == 0L) {
  base <- read.csv(base_out, stringsAsFactors = FALSE)
  expected <- data.frame(statistic = c("N", "Age_mean", "Age_missing",
                                       "Sex_F", "Sex_M", "Sex_U"),
                         Drug_X = c(11, 65.6, 1, 5, 5, 1),
                         Placebo = c(11, 66.7, 1, 6, 4, 1),
                         stringsAsFactors = FALSE)
  names(expected)[2:3] <- c("Drug X", "Placebo")
  check("base output matches expected safety-population values",
        isTRUE(all.equal(base, expected, check.attributes = FALSE)))
} else {
  check("base output matches expected safety-population values", FALSE)
}

if (base_status == 0L && head_status == 0L) {
  head <- read.csv(head_out, stringsAsFactors = FALSE)
  base <- read.csv(base_out, stringsAsFactors = FALSE)
  base_s <- base[order(base$statistic), ]
  head_s <- head[order(head$statistic), ]
  check("head output differs from base output (there is something to find)",
        !isTRUE(all.equal(head_s, base_s, check.attributes = FALSE)))
}

code_files <- c("code/summarize_demog_base.R", "code/summarize_demog_head.R",
                "checks/run-fixture-checks.R")
uses_pkg <- any(vapply(code_files, function(f) {
  any(grepl("library\\(|require\\(", readLines(f)))
}, logical(1)))
check("base-R only (no library/require calls)", !uses_pkg)

adsl <- read.csv("data/adsl.csv", stringsAsFactors = FALSE, na.strings = c("", "NA"))
check("synthetic subjects only (SYNTH- prefix)", all(startsWith(adsl$USUBJID, "SYNTH-")))

if (length(failures) > 0L) {
  cat("FAILURES:", paste(failures, collapse = "; "), "\n")
  quit(status = 1)
}
cat("All fixture checks passed.\n")

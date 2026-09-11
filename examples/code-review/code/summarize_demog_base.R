#!/usr/bin/env Rscript
# Reference implementation of the review task. Correct behavior for the
# controlled code-review fixture: safety-population demographics by arm.
# Base R only. Usage:
#   Rscript code/summarize_demog_base.R --data=data --out=/tmp/base_summary.csv

args <- commandArgs(trailingOnly = TRUE)
get_arg <- function(name, default) {
  hit <- grep(paste0("^--", name, "="), args, value = TRUE)
  if (length(hit) == 0L) default else sub(paste0("^--", name, "="), "", hit[1L])
}
data_dir <- get_arg("data", "data")
out_file <- get_arg("out", "/tmp/base_summary.csv")

adsl <- read.csv(file.path(data_dir, "adsl.csv"), stringsAsFactors = FALSE,
                 na.strings = c("", "NA"))
lookup <- read.csv(file.path(data_dir, "race_lookup.csv"), stringsAsFactors = FALSE)

adsl <- adsl[!duplicated(adsl$USUBJID), ]
safety <- adsl[adsl$SAFFL == "Y", ]
safety$RACE <- lookup$RACE[match(safety$USUBJID, lookup$USUBJID)]

arms <- sort(unique(safety$TRT01P))
one_arm <- function(arm) {
  sub <- safety[safety$TRT01P == arm, ]
  n <- nrow(sub)
  n_age_missing <- sum(is.na(sub$AGE))
  age_mean <- round(mean(sub$AGE, na.rm = TRUE), 1)
  c(N = n,
    Age_mean = age_mean,
    Age_missing = n_age_missing,
    Sex_F = sum(sub$SEX == "F"),
    Sex_M = sum(sub$SEX == "M"),
    Sex_U = sum(sub$SEX == "Unknown"))
}

res <- as.data.frame(lapply(arms, one_arm), row.names = NULL)
colnames(res) <- arms
res <- cbind(statistic = c("N", "Age_mean", "Age_missing", "Sex_F", "Sex_M", "Sex_U"), res)
write.csv(res, out_file, row.names = FALSE)

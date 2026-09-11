#!/usr/bin/env Rscript
# Pull request under review. Task: safety-population demographics by arm.
# Base R only. Usage:
#   Rscript code/summarize_demog_head.R --data=data --out=/tmp/head_summary.csv

args <- commandArgs(trailingOnly = TRUE)
get_arg <- function(name, default) {
  hit <- grep(paste0("^--", name, "="), args, value = TRUE)
  if (length(hit) == 0L) default else sub(paste0("^--", name, "="), "", hit[1L])
}
data_dir <- get_arg("data", "data")
out_file <- get_arg("out", "/tmp/head_summary.csv")

adsl <- read.csv(file.path(data_dir, "adsl.csv"), stringsAsFactors = FALSE,
                 na.strings = c("", "NA"))
lookup <- read.csv(file.path(data_dir, "race_lookup.csv"), stringsAsFactors = FALSE)

adsl$SEX[adsl$SEX == "Unknown"] <- "F"
adsl <- adsl[!is.na(adsl$AGE), ]
enrolled <- merge(adsl, lookup, by = "USUBJID")

arms <- sort(unique(enrolled$TRT01P))
one_arm <- function(arm) {
  arm_data <- enrolled[enrolled$TRT01P == arm, ]
  n <- nrow(arm_data)
  age_mean <- round(mean(arm_data$AGE), 1)
  c(N = n,
    Age_mean = age_mean,
    Age_missing = sum(is.na(arm_data$AGE)),
    Sex_F = sum(arm_data$SEX == "F"),
    Sex_M = sum(arm_data$SEX == "M"),
    Sex_U = sum(arm_data$SEX == "Unknown"))
}

res <- as.data.frame(lapply(arms, one_arm), row.names = NULL)
colnames(res) <- c("Placebo", "Drug X")
res <- cbind(statistic = c("N", "Age_mean", "Age_missing", "Sex_F", "Sex_M", "Sex_U"), res)
res <- res[order(res$statistic), ]
write.csv(res, out_file, row.names = FALSE)

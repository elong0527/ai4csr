#!/usr/bin/env Rscript
args <- commandArgs(trailingOnly = TRUE)
get_arg <- function(name) {
  m <- regmatches(args, regexec(paste0("^--", name, "=(.*)$"), args))
  v <- Filter(function(x) length(x) == 2, m)
  if (length(v) == 0) stop(paste("missing required argument --", name, sep = ""))
  v[[1]][2]
}
sap_path <- get_arg("sap")
data_path <- get_arg("data")
out_path <- get_arg("out")
code_version <- "v1.0"

sap_lines <- readLines(sap_path, warn = FALSE)
version_line <- grep("^Version:\\s*", sap_lines, value = TRUE)
window_line <- grep("^Window:\\s*", sap_lines, value = TRUE)
if (length(version_line) == 0) {
  stop("ESCALATE: SAP excerpt states no version; refusing to derive PP flags.")
}
if (length(window_line) == 0) {
  stop("ESCALATE: SAP excerpt states no visit window; refusing to derive PP flags.")
}
sap_version <- sub("^Version:\\s*", "", version_line[1])
window_days <- as.integer(sub("^Window:\\s*\\+/-\\s*([0-9]+)\\s*days.*$", "\\1", window_line[1]))
if (is.na(window_days)) {
  stop("ESCALATE: visit window is not a number of days; refusing to derive PP flags.")
}

subjects <- read.csv(data_path, stringsAsFactors = FALSE)
subjects$PPFL <- ifelse(
  subjects$DISP == "Completed" & abs(subjects$W24_OFFSET) <= window_days, "Y", "N"
)

count_cell <- function(df, arm, flag) sum(df$ARM == arm & df$PPFL == flag)
disp <- data.frame(
  row = c("Randomized (ITT)", "Per-protocol (PP)", "Excluded from PP"),
  Placebo = c(
    sum(subjects$ARM == "Placebo"),
    count_cell(subjects, "Placebo", "Y"),
    count_cell(subjects, "Placebo", "N")
  ),
  Active = c(
    sum(subjects$ARM == "Active"),
    count_cell(subjects, "Active", "Y"),
    count_cell(subjects, "Active", "N")
  )
)
disp$Total <- disp$Placebo + disp$Active

header <- paste0(
  "# Disposition table rendered from ", sap_path,
  " | sap_version=", sap_version,
  " code_version=", code_version
)
writeLines(header, out_path)
suppressWarnings(write.table(
  disp, file = out_path, append = TRUE, sep = ",",
  row.names = FALSE, quote = FALSE
))
cat("rendered", out_path, "sap_version=", sap_version, "window=+/--", window_days, "\n", sep = "")

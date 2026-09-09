#!/usr/bin/env Rscript
args_all <- commandArgs(trailingOnly = FALSE)
f <- sub("^--file=", "", args_all[grepl("^--file=", args_all)])
if (length(f) == 0) stop("run via Rscript")
root <- dirname(normalizePath(f))
args <- commandArgs(trailingOnly = TRUE)
get_arg <- function(name) {
  m <- regmatches(args, regexec(paste0("^--", name, "=(.*)$"), args))
  v <- Filter(function(x) length(x) == 2, m)
  if (length(v) == 0) stop(paste("missing required argument --", name, sep = ""))
  v[[1]][2]
}
finding_id <- get_arg("finding")
decision <- get_arg("decision")
reviewer <- get_arg("reviewer")
stopifnot(decision %in% c("accepted", "rejected", "escalated"))

state_path <- file.path(root, "..", "findings", "findings-state.json")
txt <- paste(readLines(state_path, warn = FALSE), collapse = "\n")
if (!grepl(paste0('"id": "', finding_id, '"'), txt, fixed = TRUE)) stop("unknown finding id")
if (length(grep('"id":', txt, fixed = TRUE)) > 1) stop("multi-finding state not supported")
status <- if (decision == "accepted") "acknowledged" else "unresolved"
txt <- sub('"status": "[^"]*"', paste0('"status": "', status, '"'), txt)
txt <- sub('"disposition": null', paste0('"disposition": "', decision, '"'), txt, fixed = TRUE)
txt <- sub('"disposition_by": null', paste0('"disposition_by": "', reviewer, '"'), txt, fixed = TRUE)
writeLines(txt, state_path)
cat("recorded", finding_id, "->", status, "by", reviewer, "\n")

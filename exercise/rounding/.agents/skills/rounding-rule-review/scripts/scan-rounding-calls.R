#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1L) {
  stop("usage: scan-rounding-calls.R SOURCE_DIRECTORY", call. = FALSE)
}

script_argument <- grep("^--file=", commandArgs(), value = TRUE)[[1]]
script_path <- normalizePath(sub("^--file=", "", script_argument))
source(file.path(dirname(script_path), "scan-rounding-lib.R"))

source_dir <- normalizePath(args[[1]], mustWork = TRUE)
scan <- scan_source_directory(source_dir)
output <- list(
  files = unname(as.list(scan$files)),
  candidates = scan$candidates,
  parse_errors = unname(as.list(scan$parse_errors)),
  summary = list(
    files = length(scan$files),
    candidates = length(scan$candidates),
    parse_errors = length(scan$parse_errors)
  )
)
cat(jsonlite::toJSON(
  output,
  auto_unbox = TRUE,
  pretty = TRUE,
  null = "null"
), "\n")

if (length(scan$parse_errors) > 0L) {
  quit(status = 2L)
}

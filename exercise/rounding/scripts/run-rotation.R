#!/usr/bin/env Rscript

script_argument <- grep("^--file=", commandArgs(), value = TRUE)[[1]]
script_path <- normalizePath(sub("^--file=", "", script_argument))
script_directory <- dirname(script_path)
source(file.path(script_directory, "rounding-workflow.R"))

lab_root <- dirname(script_directory)
status <- tryCatch(
  rotation_main(commandArgs(trailingOnly = TRUE), lab_root),
  error = function(error) {
    message("ERROR: ", conditionMessage(error))
    1L
  }
)
quit(status = status)

#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1L) {
  stop("usage: scan-rounding-calls.R SOURCE_DIRECTORY", call. = FALSE)
}

source_dir <- normalizePath(args[[1]], mustWork = TRUE)
catalog <- c(
  "round", "signif", "sprintf", "formatC", "format", "prettyNum",
  "as.character"
)

files <- sort(list.files(
  source_dir,
  pattern = "\\.[Rr]$",
  recursive = TRUE,
  full.names = TRUE
))

clean_field <- function(x) {
  x <- gsub("\t", " ", x, fixed = TRUE)
  x <- gsub("\r", " ", x, fixed = TRUE)
  gsub("\n", " ", x, fixed = TRUE)
}

relative_path <- function(path) {
  normalized <- normalizePath(path)
  substring(normalized, nchar(source_dir) + 2L)
}

emit <- function(record_type, file = "", line = "", function_name = "", expression = "") {
  fields <- c(record_type, file, line, function_name, expression)
  cat(paste(vapply(fields, clean_field, character(1)), collapse = "\t"), "\n", sep = "")
}

cat("record_type\tfile\tline\tfunction\texpression\n")

candidate_count <- 0L
parse_error_count <- 0L

for (path in files) {
  relative <- relative_path(path)
  emit("file", relative)
  lines <- readLines(path, warn = FALSE)
  parsed <- tryCatch(
    parse(path, keep.source = TRUE),
    error = function(error) error
  )
  if (inherits(parsed, "error")) {
    parse_error_count <- parse_error_count + 1L
    emit("parse_error", relative, expression = conditionMessage(parsed))
    next
  }

  tokens <- getParseData(parsed)
  if (is.null(tokens)) {
    next
  }
  calls <- tokens[
    tokens$token == "SYMBOL_FUNCTION_CALL" & tokens$text %in% catalog,
    c("line1", "text"),
    drop = FALSE
  ]
  if (nrow(calls) == 0L) {
    next
  }

  calls <- unique(calls[order(calls$line1, calls$text), , drop = FALSE])
  for (index in seq_len(nrow(calls))) {
    line_number <- calls$line1[[index]]
    expression <- if (line_number <= length(lines)) trimws(lines[[line_number]]) else ""
    emit("candidate", relative, line_number, calls$text[[index]], expression)
    candidate_count <- candidate_count + 1L
  }
}

emit(
  "summary",
  expression = paste0(
    "files=", length(files),
    ";candidates=", candidate_count,
    ";parse_errors=", parse_error_count
  )
)

if (parse_error_count > 0L) {
  quit(status = 2L)
}

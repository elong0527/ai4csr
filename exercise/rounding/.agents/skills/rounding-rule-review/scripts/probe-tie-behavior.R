#!/usr/bin/env Rscript

args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 3L) {
  stop(
    "usage: probe-tie-behavior.R FUNCTION DIGITS COMMA_SEPARATED_VALUES",
    call. = FALSE
  )
}

function_name <- args[[1]]
digits <- suppressWarnings(as.integer(args[[2]]))
value_text <- strsplit(args[[3]], ",", fixed = TRUE)[[1]]
values <- suppressWarnings(as.numeric(value_text))

if (!function_name %in% c("round", "formatC")) {
  stop("FUNCTION must be round or formatC", call. = FALSE)
}
if (is.na(digits) || digits < 0L || digits > 15L) {
  stop("DIGITS must be an integer from 0 through 15", call. = FALSE)
}
if (length(values) == 0L || anyNA(values) || any(!is.finite(values))) {
  stop("all probe values must be finite decimal numbers", call. = FALSE)
}
if (!requireNamespace("cards", quietly = TRUE)) {
  stop("cards 0.9.0 is required", call. = FALSE)
}
if (as.character(utils::packageVersion("cards")) != "0.9.0") {
  stop("cards 0.9.0 is required", call. = FALSE)
}

approved_numeric <- cards::round5(values, digits = digits)
approved_numeric[approved_numeric == 0] <- 0
approved <- formatC(approved_numeric, format = "f", digits = digits)

if (function_name == "round") {
  observed_numeric <- round(values, digits = digits)
  observed <- formatC(observed_numeric, format = "f", digits = digits)
} else {
  observed <- formatC(values, format = "f", digits = digits)
  observed_numeric <- suppressWarnings(as.numeric(observed))
}

negative_zero <- observed_numeric == 0 & startsWith(observed, "-")
divergence <- observed != approved | negative_zero
status <- ifelse(divergence, "FAIL", "PASS")

cat("input\tobserved\tapproved\ttie_divergence\tnegative_zero\tstatus\n")
for (index in seq_along(values)) {
  cat(
    value_text[[index]], observed[[index]], approved[[index]],
    ifelse(observed[[index]] != approved[[index]], "true", "false"),
    ifelse(negative_zero[[index]], "true", "false"), status[[index]],
    sep = "\t"
  )
  cat("\n")
}

cat(
  "summary", "", "", sum(observed != approved), sum(negative_zero),
  paste0(sum(divergence), "_of_", length(divergence), "_diverge"),
  sep = "\t"
)
cat("\n")

if (any(divergence)) {
  quit(status = 1L)
}

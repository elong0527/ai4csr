report_round <- function(value, digits) {
  base::round(value, digits = digits)
}

include_row <- function(percentage, threshold) {
  report_round(percentage, 1L) >= threshold
}

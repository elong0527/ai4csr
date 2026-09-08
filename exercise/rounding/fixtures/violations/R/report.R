include_row <- function(percentage, threshold) {
  round(percentage, digits = 1L) >= threshold
}

display_percentage <- function(percentage) {
  formatC(percentage, format = "f", digits = 1L)
}

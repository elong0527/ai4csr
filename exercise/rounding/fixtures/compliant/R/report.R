round_half_away <- function(x, digits = 0L) {
  scale <- 10^digits
  sign(x) * floor(abs(x) * scale + 0.5) / scale
}

display_percentage <- function(x) {
  value <- round_half_away(x, digits = 1L)
  if (value == 0) value <- 0
  formatC(value, format = "f", digits = 1L)
}


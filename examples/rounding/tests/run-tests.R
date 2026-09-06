args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)
script_path <- sub("^--file=", "", file_arg[[1L]])
root <- normalizePath(file.path(dirname(script_path), "../../.."))
source(file.path(root, "examples/rounding/R/triage-rounding-calls.R"))
policy <- read.csv(
  file.path(root, "examples/rounding/rules/rounding-policy.csv"),
  colClasses = "character", check.names = FALSE
)

expected <- read.csv(
  file.path(root, "examples/rounding/expected/triage.csv"),
  colClasses = "character", check.names = FALSE
)
actual <- lapply(expected$fixture, function(fixture) {
  calls <- inventory_calls(file.path(root, "examples/rounding/fixtures", fixture))
  triage <- triage_calls(calls, policy)
  counts <- table(factor(
    triage$classification,
    levels = c("approved", "prohibited", "known_non_rounding", "unresolved")
  ))
  data.frame(
    fixture = fixture,
    route = route_triage(triage),
    approved = counts[[1L]], prohibited = counts[[2L]],
    known_non_rounding = counts[[3L]], unresolved = counts[[4L]],
    stringsAsFactors = FALSE
  )
})
actual <- do.call(rbind, actual)
actual[] <- lapply(actual, as.character)
stopifnot(identical(actual, expected))
cat("All deterministic rounding triage tests passed.\n")

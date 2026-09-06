arguments <- commandArgs(trailingOnly = TRUE)
if (length(arguments) < 1L || length(arguments) > 2L) {
  stop("Usage: Rscript run-ci-gate.R <changed-R-file> [github-output-file]",
       call. = FALSE)
}
args <- commandArgs(trailingOnly = FALSE)
file_arg <- grep("^--file=", args, value = TRUE)
script_path <- sub("^--file=", "", file_arg[[1L]])
root <- normalizePath(file.path(dirname(script_path), "../.."))

source(file.path(root, "examples/rounding/R/triage-rounding-calls.R"))
policy <- read.csv(
  file.path(root, "examples/rounding/rules/rounding-policy.csv"),
  colClasses = "character", check.names = FALSE
)
calls <- inventory_calls(arguments[[1L]])
calls$file <- sub(paste0("^", root, "/?"), "", normalizePath(calls$file))
triage <- triage_calls(calls, policy)
route <- route_triage(triage)

results <- file.path(root, "examples/rounding/results")
dir.create(results, showWarnings = FALSE)
write.csv(triage, file.path(results, "triage.csv"), row.names = FALSE)
unresolved <- triage[triage$classification == "unresolved", , drop = FALSE]
write.csv(unresolved, file.path(results, "agent-queue.csv"), row.names = FALSE)

if (length(arguments) == 2L) {
  cat(sprintf("needs_agent=%s\n", tolower(route == "agent")),
      file = arguments[[2L]], append = TRUE)
}
cat(sprintf("Deterministic route: %s\n", route))
if (route == "fail") quit(status = 1L)

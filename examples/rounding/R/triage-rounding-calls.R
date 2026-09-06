call_name <- function(call) {
  head <- call[[1L]]
  if (is.symbol(head)) {
    return(as.character(head))
  }
  if (is.call(head) && identical(as.character(head[[1L]]), "::")) {
    return(paste(as.character(head[[2L]]), as.character(head[[3L]]), sep = "::"))
  }
  "<dynamic_call>"
}

inventory_calls <- function(path) {
  expressions <- parse(path, keep.source = TRUE)
  rows <- list()
  operators <- c("<-", "=", "{", "(", "[", "[[", "$", "@", "::", ":::")

  visit <- function(node) {
    if (!is.call(node)) return(invisible(NULL))
    name <- call_name(node)
    if (!name %in% operators) {
      reference <- attr(node, "srcref")
      rows[[length(rows) + 1L]] <<- data.frame(
        file = path,
        line = if (is.null(reference)) NA_integer_ else as.integer(reference[[1L]]),
        function = name,
        stringsAsFactors = FALSE
      )
    }
    for (argument in as.list(node)[-1L]) visit(argument)
    invisible(NULL)
  }

  for (expression in expressions) visit(expression)
  if (!length(rows)) {
    return(data.frame(file = character(), line = integer(), function = character()))
  }
  do.call(rbind, rows)
}

triage_calls <- function(calls, policy) {
  required_policy <- c(
    "function", "classification", "owner", "version_scope", "rationale", "source"
  )
  if (!all(required_policy %in% names(policy))) {
    stop("Rounding policy does not match the required schema.", call. = FALSE)
  }
  match_index <- match(calls$function, policy$function)
  calls$classification <- policy$classification[match_index]
  calls$classification[is.na(calls$classification)] <- "unresolved"
  calls
}

route_triage <- function(triage) {
  if (any(triage$classification == "prohibited")) return("fail")
  if (any(triage$classification == "unresolved")) return("agent")
  "pass"
}

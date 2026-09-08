ROUNDING_FUNCTION_CATALOG <- c(
  "round", "signif", "sprintf", "formatC", "format", "prettyNum",
  "as.character"
)

rounding_relative_path <- function(path, source_directory) {
  normalized <- normalizePath(path, mustWork = TRUE)
  substring(normalized, nchar(source_directory) + 2L)
}

rounding_source_span <- function(lines, row) {
  if (row$line1 == row$line2) {
    return(substr(lines[[row$line1]], row$col1, row$col2))
  }
  pieces <- c(
    substr(lines[[row$line1]], row$col1, nchar(lines[[row$line1]])),
    if (row$line2 > row$line1 + 1L) {
      lines[seq.int(row$line1 + 1L, row$line2 - 1L)]
    } else {
      character()
    },
    substr(lines[[row$line2]], 1L, row$col2)
  )
  paste(pieces, collapse = "\n")
}

rounding_call_row <- function(tokens, token_row) {
  function_expression <- tokens[tokens$id == token_row$parent, , drop = FALSE]
  if (nrow(function_expression) != 1L) {
    return(token_row)
  }
  call_expression <- tokens[
    tokens$id == function_expression$parent[[1]], , drop = FALSE
  ]
  if (nrow(call_expression) != 1L) {
    return(token_row)
  }
  call_expression
}

scan_source_directory <- function(source_directory) {
  source_directory <- normalizePath(source_directory, mustWork = TRUE)
  files <- sort(list.files(
    source_directory,
    pattern = "\\.[Rr]$",
    recursive = TRUE,
    full.names = TRUE
  ))
  relative_files <- vapply(
    files,
    rounding_relative_path,
    character(1),
    source_directory = source_directory
  )
  candidates <- list()
  parse_errors <- character()

  for (file_index in seq_along(files)) {
    path <- files[[file_index]]
    relative <- relative_files[[file_index]]
    lines <- readLines(path, warn = FALSE)
    parsed <- tryCatch(
      parse(path, keep.source = TRUE),
      error = function(error) error
    )
    if (inherits(parsed, "error")) {
      parse_errors <- c(
        parse_errors,
        sprintf("%s: %s", relative, conditionMessage(parsed))
      )
      next
    }

    tokens <- getParseData(parsed)
    if (is.null(tokens)) {
      next
    }
    calls <- tokens[
      tokens$token == "SYMBOL_FUNCTION_CALL" &
        tokens$text %in% ROUNDING_FUNCTION_CATALOG,
      ,
      drop = FALSE
    ]
    if (nrow(calls) == 0L) {
      next
    }
    calls <- calls[order(calls$line1, calls$col1, calls$id), , drop = FALSE]
    for (call_index in seq_len(nrow(calls))) {
      call <- calls[call_index, , drop = FALSE]
      expression_row <- rounding_call_row(tokens, call)
      candidate <- list(
        candidate_id = sprintf(
          "%s:%d:%d:%d",
          relative,
          call$line1[[1]],
          call$col1[[1]],
          call$id[[1]]
        ),
        file = relative,
        line = as.integer(call$line1[[1]]),
        column = as.integer(call$col1[[1]]),
        token_id = as.integer(call$id[[1]]),
        `function` = call$text[[1]],
        expression = rounding_source_span(lines, expression_row)
      )
      candidates[[length(candidates) + 1L]] <- candidate
    }
  }

  list(
    files = unname(relative_files),
    candidates = candidates,
    parse_errors = unname(parse_errors)
  )
}

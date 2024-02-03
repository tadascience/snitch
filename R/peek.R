
#' @export
informant <- function() {
  hex_pink <- cli::make_ansi_style("pink")("⬢")

  env <- parent.frame()
  calls <- sys.calls()

  call <- deparse(calls[[length(calls) - 5L]])

  header <- paste(hex_pink, cli::col_silver("call:"), call)
  content <- paste(hex_pink, cli::col_silver("env:"))
  txt <- paste("    - ", capture.output(print(ls.str(env))))

  print(cli::boxx(
    c(header, content, txt),
    padding = 1, border_col = "pink"
  ))

  invisible()
}

#' Peek function inputs
#'
#' @examples
#' fun(rnorm)
#'
#' @export
fun <- function(fun, tracer = snitch::informant, where = topenv(parent.frame())) {
  call <- sys.call()
  call[[1L]] <- quote(trace)
  call$where <- where
  call$tracer <- tracer
  eval.parent(call)
}

#' Peek all functions from a package
#'
#' @param pkg The package to snitch on
#'
#' @examples
#' pkg("dplyr")
#'
#' @export
pkg <- function(pkg, pattern = "") {}

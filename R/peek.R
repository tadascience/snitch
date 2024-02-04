#' @importFrom utils ls.str capture.output
informant <- function() {
  hex_pink <- cli::make_ansi_style("pink")("\U2B22")

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
#' @param what Function to snitch on
#'
#' @examples
#' fun(rnorm)
#'
#' @export
fun <- function(what) {
  call <- sys.call()
  call[[1L]] <- quote(trace)
  call$where <- topenv(parent.frame())
  call$tracer <- informant
  call$print <- FALSE
  suppressMessages(eval.parent(call))

  invisible()
}

#' Peek all functions from a package
#'
#' @param pkg The package to snitch on
#' @param pattern filter functions
#'
#' @examples
#' pkg("dplyr")
#'
#' @export
pkg <- function(pkg, pattern = "") {}

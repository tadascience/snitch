#' @export
informant <- function() {
  env <- parent.frame()
  calls <- sys.calls()

  pink <- cli::make_ansi_style("pink")
  call <- deparse(calls[[length(calls) - 5L]])

  print(cli::rule(col = "pink"))
  cat(pink("⬢"), cli::col_silver("call: "), call, "\n")

  print(cli::rule(col = "pink"))
  cat(pink("⬢"), cli::col_silver("env: \n"))
  print(ls.str(env))
  print(cli::rule(col = "pink"))
  invisible()
}

#' Peek function inputs
#'
#' @examples
#' peek()
#'
#' @export
peek <- function(fun) {
  fun <- substitute(fun)
  trace(fun, tracer = snitch::informant)
}

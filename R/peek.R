breadcrumbs <- function() {
  calls <- sys.calls()
  frames <- sys.frames()
  snitched <- sapply(frames, function(f) exists(".__snitch", f, inherits = FALSE))

  crumbs <- sapply(calls[snitched], function(call) {
    as.character(call[[1L]])
  })

  # TODO: figure out why eval is in there in the first place
  crumbs[crumbs != "eval"]
}

colors <- rainbow(1000)

#' @importFrom utils ls.str capture.output
informant <- function(col) {
  function() {
    assign(".__snitch", TRUE, parent.frame(n = 5))
    colored <- cli::make_ansi_style(col)
    hex <- "\U2B22"

    env <- parent.frame()

    crumbs <- paste(breadcrumbs(), collapse = paste0(" ", hex, " "))
    writeLines(colored(cli::rule(crumbs)))
    if (length(ls(env, all.names = FALSE))) {
      txt <- paste("  ", capture.output(print(ls.str(env, all.names = FALSE))))
      writeLines(colored(txt))
    }

    invisible()
  }
}

#' Snitch on functions
#'
#' @param what Function to snitch on
#' @param col color
#'
#' @examples
#' fun(rnorm)
#'
#' @export
fun <- function(what, col = "pink") {
  call <- sys.call()
  call[[1L]] <- quote(trace)
  call$where <- topenv(parent.frame())
  call$tracer <- informant(col)
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

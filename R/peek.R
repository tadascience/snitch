breadcrumbs <- function() {
  calls <- sys.calls()
  frames <- sys.frames()
  snitched <- sapply(frames, function(f) exists(".__snitch", f, inherits = FALSE))

  crumbs <- sapply(calls[snitched], function(call) {
    if (rlang::is_call(call[[1L]], "::")) {
      glue::glue("{pkg}::{fun}", pkg = call[[1L]][[2L]], fun = call[[1L]][[3L]])
    } else if (rlang::is_call(call[[1L]], ":::")) {
      glue::glue("{pkg}:::{fun}", pkg = call[[1L]][[2L]], fun = call[[1L]][[3L]])
    } else {
      as.character(call[[1L]])
    }
  })

  # TODO: figure out why eval is in there in the first place
  crumbs[crumbs != "eval"]
}

hex <- "\U2B22"

#' @importFrom utils ls.str capture.output
informant <- function(col) {
  function() {
    assign(".__snitch", TRUE, parent.frame(n = 5))
    colored <- cli::make_ansi_style(col)

    env <- parent.frame()

    crumbs <- paste(breadcrumbs(), collapse = paste0(" ", hex, " "))
    crumbs <- stringr::str_trunc(crumbs, getOption("width") - 10, side = "left", ellipsis = "[...]")
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
#' @param where where to look for the function to be snitched on
#'
#' @examples
#' fun(rnorm)
#'
#' @export
fun <- function(what, col = "pink", where = topenv(parent.frame())) {
  call <- sys.call()
  call[[1L]] <- quote(trace)
  call$where <- where
  call$tracer <- informant(col)
  call$print <- FALSE
  call$col <- NULL

  suppressMessages(eval.parent(call))

  invisible()
}

#' Snitch on functions from a package
#'
#' @param pkg The package to snitch on
#' @param pattern filter functions
#' @param col color
#'
#' @export
pkg <- function(pkg, pattern = "", col = "pink") {
  ns <- asNamespace(pkg)

  names <- ls(ns, pattern = pattern)

  for (i in seq_along(names)) {
    obj <- get(names[i], ns)
    if (!is.function(obj)) next

    snitch::fun(names[i], col = col, where = ns)
  }
}

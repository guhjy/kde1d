#' check if data violate boundaries
#' @noRd
check_boundary_violations <- function(x, xmin, xmax) {
    if (!is.nan(xmax) & !is.nan(xmin)) {
        if (any(x < xmin) || any(x > xmax))
            stop("Not all data are contained in the interval [xmin, xmax].")
    } else if (!is.nan(xmin)) {
        if (any(x < xmin))
            stop("Not all data are larger than xmin.")
    } else if (!is.nan(xmax)) {
        if (any(x > xmax))
            stop("Not all data are samller than xmax.")
    }
}

#' check and pre-process arguments passed to kde1d()
#' @noRd
check_arguments <- function(x, mult, xmin, xmax, bw, deg) {
    stopifnot(NCOL(x) == 1)

    if (!is.ordered(x) & is.factor(x))
        stop("Factors not allowed; use kdevine::kdevine() or cctools::cckde().")

    stopifnot(mult > 0)

    if (is.ordered(x) & (!is.nan(xmin) | !is.nan(xmax)))
        stop("xmin and xmax are not meaningful for x of type ordered.")

    if (!is.nan(xmax) & !is.nan(xmin)) {
        if (xmin > xmax)
            stop("xmin is larger than xmax.")
    }
    check_boundary_violations(x, xmin, xmax)

    if (!(deg %in% 0:2))
        stop("deg must be either 0, 1, or 2.")
}

#' adjusts observations and evaluation points for boundary effects
#' @importFrom stats qnorm
#' @noRd
boundary_transform <- function(x, xmin, xmax) {
    if (!is.nan(xmin) & !is.nan(xmax)) {  # two boundaries
        x <- qnorm((x - xmin) / (xmax - xmin + 1e-1))
    } else if (!is.nan(xmin)) {           # left boundary
        x <- log(x - xmin + 1e-3)
    } else if (!is.nan(xmax)) {           # right boundary
        x <- log(xmax - x + 1e-3)
    }

    x
}



<!-- README.md is generated from README.Rmd. Please edit that file -->

# snitch <a href="https://snitch.tada.science"><img src="man/figures/logo.png" align="right" height="138" /></a>

<!-- badges: start -->

[![Lifecycle:
experimental](https://img.shields.io/badge/lifecycle-experimental-orange.svg)](https://lifecycle.r-lib.org/articles/stages.html#experimental)
[![CRAN
status](https://www.r-pkg.org/badges/version/snitch)](https://CRAN.R-project.org/package=snitch)
[![R-CMD-check](https://github.com/tadascience/snitch/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/tadascience/snitch/actions/workflows/R-CMD-check.yaml)
[![Codecov test
coverage](https://codecov.io/gh/tadascience/snitch/branch/main/graph/badge.svg)](https://app.codecov.io/gh/tadascience/snitch?branch=main)
<!-- badges: end -->

The goal of snitch is to …

## Installation

You can install the development version of snitch like so:

``` r
pak::pak("tadascience/snitch")
```

## Example

``` r
# snitch on one function
snitch::fun(rnorm)

# snitch on all functions from a package
snitch::pkg("dplyr")
```

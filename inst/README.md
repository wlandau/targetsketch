
# targetsketch

This R/Shiny app is a companion to the
[`targets`](https://github.com/wlandau/targets) R package. It helps new
users learn [`targets`](https://github.com/wlandau/targets), and it
helps new and experienced users set up new
[`targets`](https://github.com/wlandau/targets)-powered projects. Simply
provide a [`_targets.R`
script](https://wlandau.github.io/targets-manual/walkthrough.html), and
`targetsketch` will show you the end-to-end dependency graph of your
workflow, a manifest of the pipeline, and produce a downloadable
`_targets.R` script to get your project started.

# Access

This app is available online at
<https://wlandau.shinyapps.io/targetsketch>. If you cannot access it,
you can install it locally in an R session.

``` r
install.packages("remotes")
remotes::install_github("wlandau/targetsketch")
```

Then run it on your own machine.

``` r
targetsketch::targetsketch()
```

# Usage

1.  Navigate to the `Pipeline` view (left sidebar).
2.  Write your [`_targets.R`
    script](https://wlandau.github.io/targets-manual/walkthrough.html)
    in the `_targets.R` box. The code must return a valid pipeline
    object at the end, ideally with a call to the
    [`tar_pipeline()`](https://wlandau.github.io/targets/reference/tar_pipeline.html)
    function. If you want the app to analyze custom functions called in
    the commands of the targets, define them in the `_targets.R` box as
    well. See the
    [`tar_script()`](https://wlandau.github.io/targets/reference/tar_script.html)
    help file for more details.
3.  Click `Update` button in the `Control` box.
4.  If you want to download the code in the `_targets.R` box as an R
    script file, click the `Download` button in the `Control` box.

# Contributing

Contributions are welcome. If you plan to [file an
issue](https://github.com/wlandau/targetsketch/issues/new/choose) or
[submit a pull request](https://github.com/wlandau/targetsketch/pulls),
please first read the [code of
conduct](https://github.com/wlandau/targetsketch/blob/main/CODE_OF_CONDUCT.md)
and [rules for
contributing](https://github.com/wlandau/targetsketch/blob/main/CONTRIBUTING.md).

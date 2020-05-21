# czechrates

<!-- badges: start -->
[![Travis build status](https://travis-ci.com/jla-data/czechrates.svg?branch=master)](https://travis-ci.com/jla-data/czechrates)
[![Coveralls test coverage](https://coveralls.io/repos/github/jla-data/czechrates/badge.svg)](https://coveralls.io/r/jla-data/czechrates?branch=master)
<!-- badges: end -->

The PRIBOR rates are provided by Czech National Bank as a courtesy of the Czech Financial Benchmark Facility s.r.o., the benchmark administrator of the PRIBOR benchmark.

The rates can be accessed for internal purposes free of charge via internet pages of ČNB - https://www.cnb.cz/en/financial-markets/money-market/pribor/format-of-the-pribor-rate-on-the-cnb-website/

The package `{czechrates}` provides a convenient way to access the information stored on the ČNB site from the comfort of your R session. It does not store the rates (this would be against the terms of use, and the data would get stale rather soon). As a consequence a working internet connection is required to use the package.

<hr>

The package currently contains a single function: `czechrates::pribor()`. 

The `pribor()` function has two parameters:

- `date` = date valid for the PRIBOR rate; default is yesterday (`Sys.Date() - 1`)

- `maturity` = tenor of the PRIBOR rate; quoted as one of the standard maturities: 1D (overnight = default), 1W (weekly) and 1M, 2M, 3M, 6M, 9M and 1Y.


## Installation

`czechrates` is currently not on CRAN. 

You are welcome to install it from GitHub by running:

``` r
remotes::install_github("jla-data/czechrates")
```

## Example

A simple example:

``` r
library(czechrates)

pribor() # overnight PRIBOR for yesterday
# A tibble: 1 x 2
  date_valid PRIBOR_1D
  <date>         <dbl>
1 2020-05-20    0.0025

pribor(as.Date("2020-04-01")) # overnight PRIBOR for April 1st, 2020
# A tibble: 1 x 2
  date_valid PRIBOR_1D
  <date>         <dbl>
1 2020-04-01    0.0101

pribor(as.Date("2020-04-01"), c("1W", "1M")) # weekly and monthly PRIBOR for April 1st, 2020
# A tibble: 1 x 3
  date_valid PRIBOR_1W PRIBOR_1M
  <date>         <dbl>     <dbl>
1 2020-04-01    0.0102      1.04

```

A graphic example:

``` r
library(czechrates)
library(ggplot2)

chart_src <- pribor(seq(from = as.Date("1997-05-01"), 
                        to = as.Date("1997-06-30"),
                        by = 1))

ggplot(data = chart_src, aes(x = date_valid, y = PRIBOR_1D)) +
  geom_line(color = "red", size = 1.25) +
  geom_point(color = "red", size = 2) +
  scale_x_date(date_labels = "%d.%m.%Y") +
  scale_y_continuous(labels = scales::percent_format()) +
  theme_bw() +
  labs(title = "A ghost of the times past, when the Asian Fever meant *monetary* contagion...",
       x = "Date",
       y = "Overnight PRIBOR (per annum)") +
  theme(plot.title = ggtext::element_markdown(size = 22))
```
<p align="center">
  <img src="https://github.com/jla-data/czechrates/blob/master/img/asian_fever.gif?raw=true" alt="Asian Fever, version 1997"/>
</p>

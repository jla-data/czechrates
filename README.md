# czechrates

<!-- badges: start -->

[![R-CMD-check](https://github.com/jla-data/czechrates/workflows/R-CMD-check/badge.svg)](https://github.com/jla-data/czechrates/actions) [![Codecov test coverage](https://codecov.io/gh/jla-data/czechrates/branch/master/graph/badge.svg)](https://codecov.io/gh/jla-data/czechrates?branch=master) [![CRAN](http://www.r-pkg.org/badges/version/czechrates)](https://cran.r-project.org/package=czechrates) [![Downloads-total](http://cranlogs.r-pkg.org/badges/grand-total/czechrates?color=brightgreen)](https://www.r-pkg.org:443/pkg/czechrates) [![Downloads-weekly](http://cranlogs.r-pkg.org/badges/last-week/czechrates?color=brightgreen)](https://www.r-pkg.org:443/pkg/czechrates)

<!-- badges: end -->

The ČNB mid FX rate is fixed by the Czech National Bank daily, and is the "official" FX rate used for accounting, taxes and customs. Even though ČNB does not actually *deal* at these rates the ČNB mid is one of the most relevant FX rates in the Czech republic – <https://www.cnb.cz/en/faq/How-does-the-CNB-calculate-the-korunas-exchange-rate-against-other-currencies/>

The PRague InterBank Offered Rates (PRIBOR - the CZK member of the broader IBOR family) are provided by the Czech National Bank as a courtesy of the Czech Financial Benchmark Facility s.r.o., the benchmark administrator of the PRIBOR benchmark. The rates can be accessed for internal purposes free of charge via internet pages of ČNB – <https://www.cnb.cz/en/financial-markets/money-market/pribor/format-of-the-pribor-rate-on-the-cnb-website/>

The two-week repo rate (a key policy rate) is formally announced by ČNB and also published on the ČNB internet – <https://www.cnb.cz/en/faq/How-has-the-CNB-two-week-repo-rate-changed-over-time/>

The package `{czechrates}` provides a convenient way to access the information stored on the ČNB site from the comfort of your R session. It does not store the rates (this would be against the terms of use, and the data would get stale rather soon). As a consequence a working internet connection is required to use the package.

<hr>

The package currently contains three functions:

-   `czechrates::cnbfxrate()` - ČNB mid FX rate
-   `czechrates::pribor()` - PRIBOR interest rate
-   `czechrates::repo2w()` - two week REPO interest rate

All functions have date valid as the first argument, with yesterday (`Sys.Date()-1`) as default.

Both functions returning interest rate report percents as fractions, i.e. a rate of 1.5% per annum is returned as 0.015, not as 1.5.

## Installation

`czechrates` is on CRAN since June 2020; to install a stable version run:

``` r
install.packages("czechrates")
```

You are welcome to install the latest development version from GitHub by running:

``` r
remotes::install_github("jla-data/czechrates")
```

The master branch should be reasoneably stable, but I do not recommend installing from development branches unless you know what you are doing. Things are bound to be somewhat rough around the edges there.

## Example

A couple use cases:

``` r
library(czechrates)

#overnight PRIBOR for yesterday
pribor()  
# A tibble: 1 x 2
  date_valid PRIBOR_1D
  <date>         <dbl>
1 2020-05-26    0.0025

# overnight PRIBOR for April 1st, 2020
pribor(as.Date("2020-04-01")) 
# A tibble: 1 x 2
  date_valid PRIBOR_1D
  <date>         <dbl>
1 2020-04-01    0.0101

# weekly and monthly PRIBOR for April 1st, 2020
pribor(as.Date("2020-04-01"), c("1W", "1M")) 
# A tibble: 1 x 3
  date_valid PRIBOR_1W PRIBOR_1M
  <date>         <dbl>     <dbl>
1 2020-04-01    0.0102    0.0104

# two-week REPO rate for yesterday
repo2w() 
# A tibble: 1 x 2
  date_valid REPO_2W
  <date>       <dbl>
1 2020-05-26  0.0025

# two-week repo rate for April 1st, 2020
repo2w(as.Date("2020-04-01")) 
# A tibble: 1 x 2
  date_valid REPO_2W
  <date>       <dbl>
1 2020-04-01    0.01

# complete list of FX rates for yesterday
cnbfxrate()
# A tibble: 33 x 6
   date_valid country    currency_name amount currency  rate
   <date>     <chr>      <chr>          <int> <chr>    <dbl>
 1 2021-04-29 Austrálie  dolar              1 AUD      16.6 
 2 2021-04-29 Brazílie   real               1 BRL       3.97
 3 2021-04-29 Bulharsko  lev                1 BGN      13.2 
 4 2021-04-29 Čína       žen-min-pi         1 CNY       3.29
 5 2021-04-29 Dánsko     koruna             1 DKK       3.47
 6 2021-04-29 EMU        euro               1 EUR      25.8 
 7 2021-04-29 Filipíny   peso             100 PHP      44.0 
 8 2021-04-29 Hongkong   dolar              1 HKD       2.74
 9 2021-04-29 Chorvatsko kuna               1 HRK       3.42
10 2021-04-29 Indie      rupie            100 INR      28.7 
# … with 23 more rows

# EUR/CZK rate for April 1st, 2020
cnbfxrate(as.Date("2020-04-01"), "EUR") 
# A tibble: 1 x 6
  date_valid country currency_name amount currency  rate
  <date>     <chr>   <chr>          <int> <chr>    <dbl>
1 2020-04-01 EMU     euro               1 EUR       27.4

# EUR/CZK rate for the week following April 1st, 2020
cnbfxrate(as.Date("2020-04-01") + 0:6, "EUR") 
# A tibble: 7 x 6
  date_valid country currency_name amount currency  rate
  <date>     <chr>   <chr>          <int> <chr>    <dbl>
1 2020-04-01 EMU     euro               1 EUR       27.4
2 2020-04-02 EMU     euro               1 EUR       27.6
3 2020-04-03 EMU     euro               1 EUR       27.5
4 2020-04-04 EMU     euro               1 EUR       27.5
5 2020-04-05 EMU     euro               1 EUR       27.5
6 2020-04-06 EMU     euro               1 EUR       27.6
7 2020-04-07 EMU     euro               1 EUR       27.2
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

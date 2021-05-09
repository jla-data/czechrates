# czechrates

<!-- badges: start -->

[![R-CMD-check](https://github.com/jla-data/czechrates/workflows/R-CMD-check/badge.svg)](https://github.com/jla-data/czechrates/actions) [![Codecov test coverage](https://codecov.io/gh/jla-data/czechrates/branch/master/graph/badge.svg)](https://codecov.io/gh/jla-data/czechrates?branch=master) [![CRAN](http://www.r-pkg.org/badges/version/czechrates)](https://cran.r-project.org/package=czechrates) [![Downloads-total](http://cranlogs.r-pkg.org/badges/grand-total/czechrates?color=brightgreen)](https://www.r-pkg.org:443/pkg/czechrates) [![Downloads-weekly](http://cranlogs.r-pkg.org/badges/last-week/czechrates?color=brightgreen)](https://www.r-pkg.org:443/pkg/czechrates)

<!-- badges: end -->

The package `{czechrates}` provides a convenient way to access the information stored on the ČNB website from the comfort of your R session. It does not store the rates (this would be against the terms of use, and the data would get stale rather soon).

As a consequence a working internet connection is required to fully use the package.

The ČNB mid FX rate is fixed against CZK by the Czech National Bank daily, and is the "official" CZK FX rate used for accounting, taxes and customs purposes. Even though ČNB does not actually *deal* at these rates the ČNB mid is one of the most relevant FX rates in the Czech republic – <https://www.cnb.cz/en/faq/How-does-the-CNB-calculate-the-korunas-exchange-rate-against-other-currencies/>

The PRague InterBank Offered Rates (PRIBOR - the CZK member of the broader IBOR family) are provided by the Czech National Bank as a courtesy of the Czech Financial Benchmark Facility s.r.o., the benchmark administrator of the PRIBOR benchmark. The rates can be accessed for internal purposes free of charge via internet pages of ČNB – <https://www.cnb.cz/en/financial-markets/money-market/pribor/format-of-the-pribor-rate-on-the-cnb-website/>

The two-week repo rate (a key policy rate) is formally announced by ČNB and also published on the ČNB internet – <https://www.cnb.cz/en/faq/How-has-the-CNB-two-week-repo-rate-changed-over-time/>

<hr>

The package currently contains three functions:

-   `czechrates::cnbfxrate()` - ČNB mid CZK FX rate
-   `czechrates::pribor()` - PRIBOR interest rate
-   `czechrates::repo2w()` - two week REPO interest rate

All functions have date valid as the first argument, with yesterday (`Sys.Date()-1`) as default.

Both functions returning interest rate use convention of reporting percents as fractions, i.e. a interest rate of 1.5% per annum would be returned as `0.015`, not as `1.5` as might be sometimes the case.

## Installation

`czechrates` is on CRAN since June 2020; to install a stable version run:

``` r
install.packages("czechrates")
```

You are welcome to install the latest development version from GitHub by running:

``` r
remotes::install_github("jla-data/czechrates")
```

The master branch should be reasonably stable, but I do not recommend installing from development branches unless you know what you are doing. Things are bound to be somewhat rough around the edges there.

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

# a complete table of CZK FX rates for yesterday
cnbfxrate()
# A tibble: 33 x 4
   date_valid currency_code amount  rate
   <date>     <chr>          <dbl> <dbl>
 1 2021-05-03 AUD                1 16.6 
 2 2021-05-03 BGN                1 13.2 
 3 2021-05-03 BRL                1  3.94
 4 2021-05-03 CAD                1 17.4 
 5 2021-05-03 CHF                1 23.4 
 6 2021-05-03 CNY                1  3.31
 7 2021-05-03 DKK                1  3.47
 8 2021-05-03 EUR                1 25.8 
 9 2021-05-03 GBP                1 29.7 
10 2021-05-03 HKD                1  2.76
# … with 23 more rows

# EUR/CZK rate for April 1st, 2020
cnbfxrate(as.Date("2020-04-01"), "EUR") 
# A tibble: 1 x 4
  date_valid currency_code amount  rate
  <date>     <chr>          <dbl> <dbl>
1 2020-04-01 EUR                1  27.4

# EUR/CZK rate for the week following April 1st, 2020
cnbfxrate(as.Date("2020-04-01") + 0:6, "EUR") 
# A tibble: 5 x 4
  date_valid currency_code amount  rate
  <date>     <chr>          <dbl> <dbl>
1 2020-04-01 EUR                1  27.4
2 2020-04-02 EUR                1  27.6
3 2020-04-03 EUR                1  27.5
4 2020-04-06 EUR                1  27.6
5 2020-04-07 EUR                1  27.2
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

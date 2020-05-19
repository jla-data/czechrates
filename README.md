
# czechrates

<!-- badges: start -->
<!-- badges: end -->

The package currently contains a single function: `czechrates::pribor()`. 

The function returns values of the [Prague Interbank Offered Rate](https://en.wikipedia.org/wiki/Prague_interbank_offered_rate) as quoted on internet pages of the [Czech National Bank](https://www.cnb.cz/en/financial-markets/money-market/pribor/fixing-of-interest-rates-on-interbank-deposits-pribor/). 

A working internet connection is therefore required to use the package.

<hr>

The `pribor()` function has two parameters:

- `date` = date valid for the PRIBOR rate; default is yesterday (`Sys.Date() - 1`)

- `maturity` = tenor of the PRIBOR rate; quoted as one of the standard maturities: 1D (overnight = default), 1W (weekly) and 1M, 2M, 3M, 6M, 9M and 1Y.


## Installation

`czechrates` is currently not on CRAN (and is uncertain to ever be). 

You are welcome to install it from GitHub by running:

``` r
remotes::install_github("jla-data/czechrates")
```

## Example

A simple example:

``` r
library(czechrates)

pribor() # overnight PRIBOR for yesterday

pribor(as.Date("2020-04-01")) # overnight PRIBOR for April 1st, 2020

pribor(as.Date("2020-04-01"), "1W") # weekly PRIBOR for April 1st, 2020
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

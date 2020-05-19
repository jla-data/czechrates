
# czechrates

<!-- badges: start -->
<!-- badges: end -->

The package currently contains a single function: `czechrates::pribor()`. The function returns values of the Prague Interbank Offer Rate as quoted on internet pages of the [Czech National Bank](https://www.cnb.cz/en/financial-markets/money-market/pribor/fixing-of-interest-rates-on-interbank-deposits-pribor/). A working internet connection is therefore required to use the package.

<hr>

The `pribor()` function has two parameters:

- `date` = date valid for the PRIBOR rate

- `maturity` = tenor of the PRIBOR rate; quoted as one of the standard maturities: 1D (overnight = default), 1W (weekly) and 1M, 2M, 3M, 6M, 9M and 1Y (annually).


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
  geom_line(color = "red") +
  scale_x_date(date_labels = "%d.%m.%Y") +
  scale_y_continuous(labels = scales::percent_format()) +
  theme_bw() +
  theme(axis.title = element_blank()) +
  labs(title = "Memory of the times when the Asian Fever meant monetary contagion...")
```
´

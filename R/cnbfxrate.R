#' Central bank exchange rate fixing
#'
#' A function returning data frame of FX rates as fixed by the central bank.
#'
#' @param date Date of publication as date, default is yesterday.
#' @param currency_code ISO Code of currency, default is ALL / complete list.
#'
#' @return data frame - date_valid, country, currency name, quoted amount, currency ISO code, rate
#' @export
#'
#' @examples cnbfxrate(as.Date("2002-08-12"))
#'
#'
#'

# exported function
cnbfxrate <- function(date = Sys.Date() - 1,
                      currency_code = "ALL") {

  network <- as.logical(Sys.getenv("NETWORK_UP", unset = TRUE)) # dummy variable to allow testing of network
  cnb <- as.logical(Sys.getenv("CNB_UP", unset = TRUE)) # dummy variable to allow testing of network


  if (!curl::has_internet() | !network) { # network is down
    message("No internet connection.")
    return(NULL)
  }

  if (httr::http_error("https://www.cnb.cz/cs/financni-trhy/devizovy-trh/kurzy-devizoveho-trhu/kurzy-devizoveho-trhu/") | !cnb) { # CNB website down
    message("Data source broken.")
    return(NULL)
  }

  # a quick reality check:
  if(!inherits(date, "Date")) stop("'date' parameter expected as a Date data type!")

  datumy <- date %>%
    unique()

  res <- lapply(datumy, downloader) %>%
    dplyr::bind_rows() %>%
    dplyr::relocate(date_valid)

  # single currency, or entire list?
  if(currency_code != "ALL") {
    res <- res %>%
      dplyr::filter(currency  == currency_code)
  }

  res

}

# downloader - a helper function to be l-applied
downloader <- function(datum = as.Date("2021-04-23")) {

  remote_path <- "https://www.cnb.cz/cs/financni-trhy/devizovy-trh/kurzy-devizoveho-trhu/kurzy-devizoveho-trhu/denni_kurz.txt?date=" # remote archive
  remote_file <- paste0(remote_path, as.character(datum, "%d.%m.%Y")) # path to ČNB source data
  local_file <- file.path(tempdir(), paste0(datum, ".txt")) # local file - in tempdir

  if (!file.exists(local_file)) {

    # proceed to download via curl
    curl::curl_download(url = remote_file, destfile = local_file, quiet = T)
  } # /if - local file exists

  local_df <- readr::read_delim(local_file,
                                delim = "|", skip = 2,
                                locale = readr::locale(decimal_mark = ",", grouping_mark = "."),
                                col_names = c(
                                  "country",
                                  "currency_name",
                                  "amount",
                                  "currency",
                                  "rate"
                                ),
                                col_types = readr::cols(
                                  country = readr::col_character(),
                                  currency_name = readr::col_character(),
                                  amount = readr::col_integer(),
                                  currency = readr::col_character(),
                                  rate = readr::col_double()
                                )
  )

  attr(local_df, 'spec') <- NULL

  local_df$date_valid = datum

  local_df
} # /function


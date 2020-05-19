#' Internal function - generic downloader of raw data from www.cnb.cz
#'
#' @param year file to be downloaded
#' @param verbose should progress messages be displayed? Default is not.
#' @return data frame of annual pribor & pribid rates
#' @keywords internal

downloader <- function(year, verbose = FALSE) {
  network <- as.logical(Sys.getenv("NETWORK_UP", unset = TRUE)) # dummy variable to allow testing of network
  cnb <- as.logical(Sys.getenv("CNB_UP", unset = TRUE)) # dummy variable to allow testing of network

  remote_path <- "https://www.cnb.cz/en/financial-markets/money-market/pribor/fixing-of-interest-rates-on-interbank-deposits-pribor/year.txt?year=" # remote archive

  remote_file <- paste0(remote_path, year) # path to ČNB source data
  local_file <- file.path(tempdir(), paste0(year, ".txt")) # local file - in tempdir

  if (file.exists(local_file)) {
    if (verbose) message("czechrates: using temporary local dataset.")
  } else {
    if (!curl::has_internet() | !network) { # network is down
      message("No internet connection.")
      return(NULL)
    }

    if (httr::http_error(remote_file) | !cnb) { # ČNB website down
      message("Data source broken.")
      return(NULL)
    }

    # proceed to download via curl
    if (verbose) message("czechrates: downloading remote dataset.")
    curl::curl_download(url = remote_file, destfile = local_file, quiet = T)
  } # /if - local file exists

  local_df <- readr::read_delim(local_file,
    delim = "|", skip = 2,
    col_names = c(
      "date_valid",
      "PRIBID_1D", "PRIBOR_1D",
      "PRIBID_1W", "PRIBOR_1W",
      "PRIBID_2W", "PRIBOR_2W",
      "PRIBID_1M", "PRIBOR_1M",
      "PRIBID_2M", "PRIBOR_2M",
      "PRIBID_3M", "PRIBOR_3M",
      "PRIBID_6M", "PRIBOR_6M",
      "PRIBID_9M", "PRIBOR_9M",
      "PRIBID_1Y", "PRIBOR_1Y"
    ),
    col_types = readr::cols(
      date_valid = readr::col_date(format = "%d %b %Y"),
      PRIBID_1D = readr::col_double(),
      PRIBOR_1D = readr::col_double(),
      PRIBID_1W = readr::col_double(),
      PRIBOR_1W = readr::col_double(),
      PRIBID_2W = readr::col_double(),
      PRIBOR_2W = readr::col_double(),
      PRIBID_1M = readr::col_double(),
      PRIBOR_1M = readr::col_double(),
      PRIBID_2M = readr::col_double(),
      PRIBOR_2M = readr::col_double(),
      PRIBID_3M = readr::col_double(),
      PRIBOR_3M = readr::col_double(),
      PRIBID_6M = readr::col_double(),
      PRIBOR_6M = readr::col_double(),
      PRIBID_9M = readr::col_double(),
      PRIBOR_9M = readr::col_double(),
      PRIBID_1Y = readr::col_double(),
      PRIBOR_1Y = readr::col_double()
    )
  )

  local_df
} # /function

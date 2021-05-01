#' pribor
#'
#' A function returning data frame of PRague InterBank OffeRed rates (PRIBOR).
#'
#' The function expects date input, and returns data frame of two or more columns - date, and relevant PRIBOR rate (as determined by `maturity` parameter).
#'
#' PRIBOR rates are reported as fractions, i.e. not as percentages (i.e. 1\% is reported as .01, not 1).
#'
#' For dates when no PRIBOR was quoted (e.g. weekends, Bank Holidays, such as December 24th on any year, or August 13th, 2002 when no PRIBOR was quoted due to catastrophic floods) no result will be returned.
#'
#' @name pribor
#'
#' @param date Date of fixing as date, default is yesterday.
#' @param maturity Maturity of loan as string, default is overnight ("1D").
#'
#' @return data frame - first column is date, second is relevant PRIBOR rate.
#' @export
#'
#' @examples pribor(as.Date("2002-08-12"), "1D")
#'



# exported function...
pribor <- function(date = Sys.Date() - 1, maturity = "1D") {

  cnb <- as.logical(Sys.getenv("CNB_UP", unset = TRUE)) # dummy variable to allow testing of network

  if (!ok_to_proceed("https://www.cnb.cz/en/financial-markets/money-market/pribor/fixing-of-interest-rates-on-interbank-deposits-pribor/year.txt") | !cnb) { # CNB website down
    message("Data source broken.")
    return(NULL)
  }

  # a quick reality check:
  if(!inherits(date, "Date")) stop("'date' parameter expected as a Date data type!")
  if(!all(maturity %in% c("1D", "1W", "2W", "1M", "3M", "6M", "9M", "1Y"))) stop(paste0("'", maturity, "' is not a recognized maturity abbreviation!"))

  roky <- format(date, "%Y") %>%
    unique()

  sazba <- paste0("PRIBOR_", maturity)

  res <- lapply(roky, dnl_pribor) %>%
    dplyr::bind_rows() %>%
    dplyr::filter(date_valid %in% date) %>%
    dplyr::select(date_valid, !! sazba) %>%
    dplyr::mutate_if(is.numeric,  ~ . / 100) %>%
    dplyr::arrange(date_valid)

  res

}

# downloader - a helper function to be l-applied
dnl_pribor <- function(year) {

  remote_path <- "https://www.cnb.cz/en/financial-markets/money-market/pribor/fixing-of-interest-rates-on-interbank-deposits-pribor/year.txt?year=" # remote archive
  remote_file <- paste0(remote_path, year) # path to ČNB source data
  local_file <- file.path(tempdir(), paste0(year, ".txt")) # local file - in tempdir

  if (!file.exists(local_file)) {

    # proceed to download via curl
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

  attr(local_df, 'spec') <- NULL

  local_df
} # /function


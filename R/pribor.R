
#' Pribor
#'
#' A function returning data frame of PRIBOR rates.
#'
#' The function expects date input, and returns data frame of two columns - date, and relevant PRIBOR rate (as determined by `maturity` parameter).
#'
#' PRIBOR rates are reported as fractions, i.e. not as percentages (1% = .01).
#'
#' For dates when no PRIBOR was quoted (e.g. Bank Holidays, such as December 24th on any year, or August 13th, 2002 when no PRIBOR was quoted due to catastrophic floods) no result will be returned.
#'
#' @param date Date of fixing as date, default is yesterday.
#' @param maturity Maturity of loan as string, default is overnight ("1D").
#'
#' @return data frame - first column is date, second is relevant PRIBOR rate.
#'
#' @export
#'
#' @importFrom magrittr %>%
#'
#' @examples pribor(as.Date("2002-08-12"))
#'
pribor <- function(date = Sys.Date() - 1, maturity = "1D") {

  # a quick reality check:
  if(!inherits(date, "Date")) stop("'date' parameter expected as a Date data type!")
  if(!is.element(maturity, c("1D", "1W", "2W", "1M", "3M", "6M", "9M", "1Y"))) stop(paste0("'", maturity, "' is not a recognized maturity abbreviation!"))

  roky <- format(date, "%Y") %>%
    unique()

  sazba <- paste0("PRIBOR_", maturity)

  res <- lapply(roky, downloader) %>%
    dplyr::bind_rows() %>%
    dplyr::filter(date_valid %in% date) %>%
    dplyr::select(date_valid, !! sazba) %>%
    dplyr::mutate_at(dplyr::vars(2),  ~ . / 100) %>%
    dplyr::arrange(date_valid)

  res

}

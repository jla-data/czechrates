#' Two-week Repo Rate
#'
#' A function returning data frame of two-week repo rate, as set by ČNB.
#'
#' The function expects date input, and returns data frame of two columns - date, and relevant repo rate. It does not require maturity argument, as maturity is by definition 2W.
#'
#' Repo rates are reported as fractions, i.e. not as percentages (i.e. 1\% is reported as .01, not 1).
#'
#' A single result will be reported for all dates higher than December 8th, 1995.
#'
#' @param date Date of fixing as date, default is yesterday.
#'
#' @return data frame - first column is date, second is relevant two-week repo rate (the primary CZK policy rate)
#' @export
#'
#' @examples repo2w(as.Date("2002-08-12"))
#'
repo2w <- function(date = Sys.Date() - 1) {

  # a quick reality check:
  if(!inherits(date, "Date")) stop("'date' parameter expected as a Date data type!")

  network <- as.logical(Sys.getenv("NETWORK_UP", unset = TRUE)) # dummy variable to allow testing of network
  cnb <- as.logical(Sys.getenv("CNB_UP", unset = TRUE)) # dummy variable to allow testing of network

  remote_file <- "https://www.cnb.cz/cs/casto-kladene-dotazy/.galleries/vyvoj_repo_historie.txt" # path to ČNB source data
  local_file <- file.path(tempdir(), "vyvoj_repo_historie.txt") # local file - in tempdir

  if (!file.exists(local_file)) {
    if (!curl::has_internet() | !network) { # network is down
      message("No internet connection.")
      return(NULL)
    }

    if (httr::http_error(remote_file) | !cnb) { # ČNB website down
      message("Data source broken.")
      return(NULL)
    }

    # proceed to download via curl
    curl::curl_download(url = remote_file, destfile = local_file, quiet = T)
  } # /if - local file exists

  local_df <- readr::read_delim(local_file,
                                delim = "|", skip = 2,
                                col_names = c(
                                  "valid_from", "REPO_2W"
                                ),
                                col_types = readr::cols(
                                  valid_from = readr::col_date(format = "%Y%m%d"),
                                  REPO_2W = readr::col_double()
                                  ),
                                locale = readr::locale(decimal_mark = ',')
                                )

  res <- local_df %>%
    dplyr::mutate(valid_to = dplyr::lead(valid_from, 1, default = Sys.Date()),
                  fake = 1)

  calendar <- data.frame(date_valid = seq(min(res$valid_from), max(res$valid_to), by = 1),
                         fake = 1) %>%
    tibble::as_tibble()

  res <- dplyr::full_join(calendar, res, by = "fake") %>%
    dplyr::select(-fake) %>%
    dplyr::filter(valid_to >= date_valid & valid_from < date_valid) %>%
    dplyr::filter(date_valid %in% date) %>%
    dplyr::mutate_at(dplyr::vars(3),  ~ . / 100) %>%
    dplyr::select(1, 3)

  res #

}


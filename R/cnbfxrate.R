#' Central bank exchange rate fixing
#'
#' A function returning data frame of FX rates as fixed by the central bank.
#'
#' @param date Date of publication as date, default is yesterday.
#' @param specific_currency ISO Code of currency, default is ALL / complete list.
#'
#' @return a data frame - date_valid, currency ISO code, quoted amount, rate
#' @export
#'
#' @examples
#' \donttest{
#'   cnbfxrate(as.Date("2002-08-12"), "EUR") # EUR/CZK rate for August 12th, 2002
#' }
#'

# exported function
cnbfxrate <- function(date = Sys.Date() - 1,
                      specific_currency = "ALL") {

  cnb <- as.logical(Sys.getenv("CNB_UP", unset = TRUE)) # dummy variable to allow testing of network

  # a quick reality check:
  if(!inherits(date, "Date")) stop("'date' parameter expected as a Date data type!")

  if (!ok_to_proceed("https://www.cnb.cz/cs/financni-trhy/devizovy-trh/kurzy-devizoveho-trhu/kurzy-devizoveho-trhu/") | !cnb) { # CNB website down
    message("Data source broken.")
    return(NULL)
  }


  roky <- format(date, "%Y") %>%
    unique()

  res <- lapply(roky, dnl_fx) %>%
    dplyr::bind_rows() %>%
    dplyr::filter(date_valid %in% date) %>%
    dplyr::relocate(date_valid, currency_code, amount, rate)


  # single currency, or entire list?
  if(specific_currency != "ALL") {

    res <- subset(res, currency_code == specific_currency)
  }

    res

} # / exported function

# downloader - a helper function to be l-applied
dnl_fx <- function(year) {


  remote_path <- "https://www.cnb.cz/cs/financni-trhy/devizovy-trh/kurzy-devizoveho-trhu/kurzy-devizoveho-trhu/rok.txt?rok=" # remote archive
  remote_file <- paste0(remote_path, year) # path to ČNB source data
  local_file <- file.path(tempdir(), paste0("fx-", year, ".txt")) # local file - in tempdir

  if (!file.exists(local_file)) {

    # proceed to download via curl
    curl::curl_download(url = remote_file, destfile = local_file, quiet = T)
    Sys.sleep(1/1000) # a tiny delay to finish saving file

  } # /if - local file exists

  raw_file <- readLines(local_file) # to obtain header rows

  useky <- c(grep("Datum", raw_file), # header rows - old version
             grep("Date", raw_file), # header rows - new version
             length(raw_file)+1) # + the end

  for (i in 1:(length(useky)-1)) {

    # i-th header row, as a list
    hlavicka <- strsplit(raw_file[useky[i]][1], split = "[|]")

    # header row without first element (datum) as a long tibble
    header <- unlist(hlavicka)[-1] %>%
      tibble::enframe(name = NULL) %>%
      tidyr::separate(sep = "\\s",
                      col = "value",
                      into = c("amount", "currency_code")) %>%
      dplyr::mutate(dplyr::across(1, as.numeric))

    # the data rows / header is skipped
    local_df <- readr::read_delim(local_file,
                                  delim = "|", skip = useky[i], n_max = useky[i+1] - useky[i] -1,
                                  locale = readr::locale(decimal_mark = ",", grouping_mark = "."),
                                  col_names = FALSE,
                                  col_types = readr::cols(
                                    X1 = readr::col_date(format = "%d.%m.%Y"),
                                    .default = readr::col_double()
                                  )) %>%
      dplyr::rename(date_valid = X1) %>%
      tidyr::pivot_longer(cols = starts_with("X"),
                          values_to = "rate") %>%
      dplyr::select(-name)

    # recycling vectors in a tible / oh so taboo... :)
    times <- nrow(local_df) / nrow(header)
    local_df$amount <- rep(header$amount, times)
    local_df$currency_code <- rep(header$currency_code, times)

    if(i >= 2) {
      vystup <- dplyr::bind_rows(vystup, local_df)
    } else {
      vystup <- local_df
    }

  } #/ for

  # get rid of that pesky readr artefact
  attr(vystup, 'spec') <- NULL

  vystup
} # / helper function


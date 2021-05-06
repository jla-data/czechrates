#' czechrates: Czech Interest Rates
#'
#' Interface to interest and FX rates as published by the Czech National Bank.
#'
#'
#' @docType package
#' @name czechrates-package
#' @keywords internal
#' @importFrom magrittr %>%

globalVariables(names = c("date_valid", "valid_from", "valid_to",
                          "fake", "currency", "X1", "amount", "currency_code",
                          "name", "rate", "starts_with"))


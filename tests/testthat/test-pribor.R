library(dplyr)

test_that("expected input failures", {

  skip_on_cran()

  expect_error(pribor("asdf")) # není datum
  expect_error(pribor(as.Date("2020-04-01"), "asdf")) # není platná maturita
  expect_error(pribor(as.Date("2020-04-01"), c("1D", "asdf"))) # není platná maturita
})

test_that("network failures", {

  skip_on_cran()

  Sys.setenv("CNB_UP" = FALSE)
  expect_message(pribor(), "source") # zpráva o spadlé ČNB
  Sys.setenv("CNB_UP" = TRUE)

})

test_that("data format", {

  skip_on_cran()

  expect_true(is.data.frame(pribor()))
  expect_true(inherits(pull(pribor(), 1), "Date"))
  expect_true(inherits(pull(pribor(), 2), "numeric"))
  expect_equal(ncol(pribor()), 2)
  expect_equal(ncol(pribor(as.Date("2020-05-19"), c("1D", "1W"))), 3)
  expect_equal(nrow(pribor(seq(from = as.Date("2020-02-24"),
                               to   = as.Date("2020-02-28"),
                               by = 1))), 5)
})

test_that("known values", {

  skip_on_cran()

  expect_equal(pribor(as.Date("1997-05-29"))$PRIBOR_1D, 194.38  / 100)
  expect_equal(pribor(as.Date("1997-05-29"), c("1D", "1W"))$PRIBOR_1W, 85.63 / 100)
})


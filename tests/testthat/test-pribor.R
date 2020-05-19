library(dplyr)

test_that("expected input failures", {
  expect_error(pribor("asdf")) # není datum
  expect_error(pribor(as.Date("2020-04-01"), "asdf")) # není platná maturita
})

test_that("data format", {
  expect_true(is.data.frame(pribor()))
  expect_true(inherits(pull(pribor(), 1), "Date"))
  expect_true(inherits(pull(pribor(), 2), "numeric"))
  expect_equal(ncol(pribor()), 2)
})

test_that("known values", {
  expect_equal(pribor(as.Date("1997-05-29"))$PRIBOR_1D, 194.38  / 100)
  expect_equal(pribor(as.Date("1997-05-29"), "1W")$PRIBOR_1W, 85.63 / 100)
})


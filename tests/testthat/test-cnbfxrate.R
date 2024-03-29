library(dplyr)

test_that("expected input failures", {

  skip_on_cran()

  expect_error(cnbfxrate("asdf")) # není datum
})

test_that("network failures", {

  skip_on_cran()

  Sys.setenv("CNB_UP" = FALSE)
  expect_message(cnbfxrate(), "source") # zpráva o spadlé ČNB
  Sys.setenv("CNB_UP" = TRUE)

})

test_that("data format", {

  skip_on_cran()

  expect_true(is.data.frame(cnbfxrate()))
  expect_gt(nrow(cnbfxrate(date = as.Date("2020-04-01"), "ALL")), 1) # všechny měny explicitně
  expect_gt(nrow(cnbfxrate(date = as.Date("2020-04-01"))), 1) # všechny měny implicitně
  expect_equal(nrow(cnbfxrate(as.Date("2020-04-01"), "EUR")), 1) # jednen datum, jedno ojro
  expect_equal(nrow(cnbfxrate(as.Date(c("2020-04-01", "2020-04-02")) , "EUR")), 2) # dva datumy, dvě ojra
  expect_equal(nrow(cnbfxrate(seq(from = as.Date("2020-12-31"),
                                  to = as.Date("2021-01-04"),
                                  by = 1) , "EUR")), 2) # dva pracovní datumy, dvě ojra
  expect_equal(nrow(cnbfxrate(seq(from = as.Date("2005-01-01"),
                                  to = as.Date("2005-12-31"),
                                  by = 1) , "EUR")), 253) # celý rok = 253 záznamů (+3 hlavičky)
})

test_that("known values", {

  skip_on_cran()

  expect_equal(cnbfxrate(as.Date("2020-04-01"), "EUR")$rate, 27.380)
  expect_equal(cnbfxrate(as.Date("2020-04-01"), "ILS")$rate, 7.019)
})


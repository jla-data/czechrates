library(dplyr)

test_that("expected input failures", {
  expect_error(repo2w("asdf")) # není datum
  expect_error(repo2w(as.Date("2020-04-01"), "asdf")) # není platná maturita
  expect_error(repo2w(as.Date("2020-04-01"), c("1D", "asdf"))) # není platná maturita
})

test_that("network failures", {

  Sys.setenv("CNB_UP" = FALSE)
  expect_message(repo2w(), "source") # zpráva o spadlé ČNB
  Sys.setenv("CNB_UP" = TRUE)

})

test_that("data format", {
  expect_true(is.data.frame(repo2w()))
  expect_true(inherits(pull(repo2w(), 1), "Date"))
  expect_true(inherits(pull(repo2w(), 2), "numeric"))
  expect_equal(ncol(repo2w()), 2)
  expect_equal(nrow(repo2w(seq(from = as.Date("2020-02-24"),
                               to   = as.Date("2020-02-28"),
                               by = 1))), 5)
})

test_that("known values", {
  expect_equal(repo2w(as.Date("1997-05-29"))$REPO_2W, 12.4  / 100)
  expect_equal(repo2w(as.Date("2020-04-01"))$REPO_2W, 1 / 100)
  expect_equal(repo2w()$date_valid, Sys.Date() - 1)
})


## Test environments
* Ubuntu 22.04.3 LTS, R version 4.3.1 (2023-06-16) (local)

* Windows R version 4.3.1 (2023-06-16 ucrt) (win-builder)
* Windows R version 4.2.3 (2023-03-15 ucrt) (win-builder)
* Windows R Under development (unstable) (2023-09-07 r85102 ucrt) (win-builder)

* Microsoft Windows Server 2022 10.0.20348, R version 4.3.1 (2023-06-16 ucrt) (GitHub Actions)
* macOS 12.6.8 21G725, R version 4.3.1 (2023-06-16) (GitHub Actions)
* Ubuntu 22.04.3 LTS, R version 4.3.1 (2023-06-16) (GitHub Actions)
* Ubuntu 22.04.3 LTS, R Under development (unstable) (2023-09-06 r85088) (GitHub Actions)
* Ubuntu 22.04.3 LTS, R version 4.2.3 (2023-03-15) (GitHub Actions)

## R CMD check results
Status: OK

## Downstream dependencies
There are no downstream dependencies.

## CRAN checks
This submission resolves the error thrown for version 0.2.2 CRAN machines, triggered by an internet resource / connectivity failure.

Since the one and only purpose of the package is API wrapping the test set and package vignette were amended in order to enhance compliance with the standing policy of a graceful fail in case of internet resource failure. 

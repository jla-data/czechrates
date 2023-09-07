# božstva CRAN-u žádají oběti...

library(knitr)
system("rm ./vignettes/vignette.Rmd")
system("rm -rf ./vignettes/*.png")
knit("./vignettes/vignette.Rmd.orig",
     output = "./vignettes/vignette.Rmd")


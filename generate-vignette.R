# božstva CRAN-u žádají oběti...

library(knitr)
system("rm ./vignettes/vignette.Rmd")
system("rm -rf ./vignettes/figure")
knit("./vignettes/vignette.Rmd.orig",
     output = "./vignettes/vignette.Rmd")
system("mkdir ./vignettes/figure/")
system("mv ./figure/* ./vignettes/figure/")

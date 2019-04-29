#install.packages( c("jsonlite", "lubridate", "quantmod"))
library(quantmod)
library(lubridate)
library(jsonlite)

###############year_change <- function(x) ############################
year_change_108_to_2019 <- function(x) {#2/29 is not allowed to transform
  b <- ymd(x)
  a <- year(b)
  a <- a + 1911
  year(b) <- a
  return(b)
}




###############date_set_all <- function(x) {############################
date_set_all <- function(x){
  dateset <- NULL
  for(i in c(2000:year(Sys.time())) ){
    for(k in c(1:12)){
      if(k >= 10){
        d <- paste0(i, k, 0, 1)
      }else{
        d <- paste0(i, 0, k, 0, 1)
      }
      if(Sys.time() >= ymd(d)){
        dateset <- c(dateset, d)
      }
    }
  }
  return(dateset)
}
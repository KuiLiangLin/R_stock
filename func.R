#install.packages quantmod
library(quantmod)
#install.packages tidyverse
library(lubridate)# for year 2019 <-> 108
#install.packages jsonlite
library(jsonlite)# for url json format

###############year_change <- function(x) {############################
year_change_108_to_2019 <- function(x) {
  b <- ymd(x)
  a <- year(b)
  a <- a + 1911
  year(b) <- a
  return(b)
}

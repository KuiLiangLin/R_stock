#install.packages( c("jsonlite", "lubridate", "quantmod"))
library(quantmod)
library(lubridate)
library(jsonlite)


###############year_change <- function(x) ############################
year_change_108_to_2019 <- function(x) {#2/29 is not allowed to transform
  da <- ymd(x)
  ye <- year(da)
  ye <- ye + 1911
  year(da) <- ye
  return(da)
}


###############date_set_all <- function(x) {############################
# if( month(Sys.time()) >= 10){
#   today <- paste0( year(Sys.time()), month(Sys.time()), day(Sys.time()) )
# } else{
#   today <- paste0( year(Sys.time()), 0, month(Sys.time()), day(Sys.time()) )
# }
date_set_all <- function(startyear){
  dateset <- NULL
  for(i in c(startyear : year(Sys.time())) ){
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



###############read_csv_to_xts <- function(x) {############################
read_csv_to_xts <- function(x) {
  rcsv <- read.csv(x)
  colnames(rcsv) <- c("Date", "Open", "High", "Low", "Close", "Volume", "Value") 
  rcsv <- xts(rcsv[, -1], order.by = as.Date(rcsv[, 1])) 
  return(rcsv)
}


###############xts_update <- function(x) {############################
xts_update <- function(mother_file, new_data) {
  mother_file_new <- mother_file
  count <- 0
  Len <- 1/dim(new_data)[1]
  for(i in c( 1:dim(new_data)[1] ) ){
    do <- 1
    for(j in c(1:dim(mother_file)[1]  ) ){
      if(index(mother_file[j,]) == index(new_data[i,])){
        do <- 0
      }
    }
    if(do == 1){
      mother_file_new <- rbind(mother_file_new, new_data[i,])
      count <- count + 1
    }
    if( round(Len*100) < round((Len + 1/dim(new_data)[1])*100) ){
      cat(">>>",round(Len*100),"%",sep = "") 
    }
    Len <- Len + 1/dim(new_data)[1]
  }
  cat("\nUpdated",count,"times")
  return(mother_file_new)
}
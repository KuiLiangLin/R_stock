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
get_date_set_all <- function(startyear){
  dateset <- NULL
  co <- 0
  for(i in c(startyear : year(Sys.time())) ){
    for(k in c(1:12)){
      if(k >= 10){
        d <- paste0(i, k, 0, 1)
      }else{
        d <- paste0(i, 0, k, 0, 1)
      }
      if(Sys.time() >= ymd(d)){
        dateset <- c(dateset, d)
         co <- co + 1
      }
    }
  }
  cat("Get", co, "Months\n")
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
xts_update <- function(mother_file, new_data, new_data_df) {
  # mother_file_new <- mother_file
  mother_file_new <- NULL
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
      mother_file_new <- rbind(mother_file_new, new_data_df[i,])
      count <- count + 1
    }
    if( round(Len*100) < round((Len + 1/dim(new_data)[1])*100) ){
      cat(">>>",round(Len*100),"%",sep = "")
    }
    Len <- Len + 1/dim(new_data)[1]
  }
  cat("\nUpdated",count,"times\n")
  return(mother_file_new)
}


###############get_stock_num_list <- function(x) {############################
get_stock_num_list <- function(recent_open_day) {
#  recent_open_day <- 20190418
  ttime <- as.character(as.integer(as.POSIXct(Sys.time()))*100)
  Sys.sleep(runif(1,2,3))#randomly delay 1 time between 2 and 3 seconds 
  url_1 <- paste0('http://www.twse.com.tw/exchangeReport/BWIBBU_d?',
                  'response=json&date=',recent_open_day,'&selectType=ALL&_=',ttime)
  jsondata <- fromJSON(url_1)
  if(jsondata$stat == "OK"){
    stockno <- jsondata$data[, 1]
  } else {
    cat("Fail to get stock number\n")
  }
  cat("Get",length(stockno),"stock number\n")
  return(stockno)
}


###############show_percet_len <- function(x) {############################
show_percet_len <- function(Len, x, data) {
  if(is.null(Len)){Len <- 1/length(data)}
  if( round(Len*100) < round((Len + 1/length(data)[1])*100) ){
    cat(">>>",round(Len*100),"%",sep = "") 
  }
  Len <- Len + 1/length(data)[1]
  if(x == last(data)){cat("\nGet",length(data),"data\n")}
  return(Len)
}

###############show_percet_dim <- function(x) {############################
show_percet_dim <- function(Len, x, data) {
  if(is.null(Len)){Len <- 1/dim(data)}
  if( round(Len*100) < round((Len + 1/dim(data)[1])*100) ){
    cat(">>>",round(Len*100),"%",sep = "") 
  }
  Len <- Len + 1/dim(data)[1]
  if(x == last(data)){cat("\nGet",dim(data),"data\n")}
  return(Len)
}

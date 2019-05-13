#install.packages( c("jsonlite", "lubridate", "quantmod"))
library(quantmod)
library(lubridate)
library(jsonlite)
source("func.R")
source("DOHLCV.R")

#------------------------------------data_DOHLCV----------------------------------------------
 source("func.R"); stock_list <- get_stock_num_list("20190429")
 source("func.R"); date_set <- get_date_set_all(2014)

 file_path <- paste0(getwd(), "/data_DOHLCV/")
 file_name <- paste0(file_path, stock_list[4],".csv")
 if(dir.exists(file_path) == FALSE){ dir.create(file_path)}
 source("DOHLCV.R"); update_DOHLCV(date_set[8:10], stock_list[3:4], file_path)
 source("func.R"); rcsv_xts <- read_csv_to_xts(file_name)
#chartSeries(rcsv_xts)

 
 
#------------------------------------month_report_revenue----------------------------------------------
 library(rvest)
 for(y in c(103:103)){
  for(mo in c(1:1)){
    cat(y,mo)
    Sys.sleep(runif(1,2,4))#randomly delay 1 time between 2 and 3 seconds 
    if(mo <= 9){file_name_mon <- paste0(y,"0",mo)}else{file_name_mon <- paste0(y,mo)}
    source("MON_REV.R"); month_report_revenue(file_name_mon, y, mo)
  }         
 }
 # rcsv <- read.csv(file_name_mon)
 # colnames(rcsv) <- c("num", "revenue") 
 


#------------------------------------season report----------------------------------------------
 
library(rvest)
for(y in c(103:103)){
  for(z in c(1:4)){
    cat(paste0(y,"0",z))
    Sys.sleep(runif(1,3,4))#randomly delay 1 time between 2 and 3 seconds 
    file_name_season <- paste0(y,"0",z)
    source("SEASON_EPS.R");season_report_eps(file_name_season, y, z) 
  }
}
 # rcsv <- read.csv(file_name_mon)


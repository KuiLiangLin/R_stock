#install.packages( c("jsonlite", "lubridate", "quantmod"))
library(quantmod)
library(lubridate)
library(jsonlite)
source("func.R")
source("DOHLCV.R")

source("func.R"); stock_list <- get_stock_num_list("20190429")

source("func.R"); date_set <- get_date_set_all(2000)



file_path <- paste0(getwd(), "/data_DOHLCV/")
file_name <- paste0(file_path, stock_list[4],".csv")
if(dir.exists(file_path) == FALSE){ dir.create(file_path)}
source("DOHLCV.R"); update_DOHLCV(date_set[8:10], stock_list[3:4], file_path)

source("func.R"); rcsv_xts <- read_csv_to_xts(file_name)
chartSeries(rcsv_xts)

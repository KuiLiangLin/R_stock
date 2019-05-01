#install.packages( c("jsonlite", "lubridate", "quantmod"))
library(quantmod)
library(lubridate)
library(jsonlite)
source("func.R")
source("DOHLCV.R")

source("func.R"); stock_n_list <- get_stock_num_list("20190417")

source("func.R"); date_set <- get_date_set_all(2000)



file_path <- paste0(getwd(), "/data_DOHLCV/")
if(dir.exists(file_path) == FALSE){ dir.create(file_path)}
source("DOHLCV.R"); update_DOHLCV(date_set[2:8], stock_n_list[1:2], file_path)


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
#chartSeries(rcsv_xts)




# 
 # library(compiler)
 library(rvest)
 stats <- read_html("http://mops.twse.com.tw/nas/t21/sii/t21sc03_108_3_0.html", encoding = 'ISO-8859-1')
 file_name_mon <- "10803"
 source("MON_REV.R"); month_report_revenue(stats,file_name_mon)
# rcsv <- read.csv(file_name_mon)
# colnames(rcsv) <- c("num", "revenue") 










#season report
#http://mops.twse.com.tw/mops/web/ajax_t163sb04?encodeURIComponent=1&step=1&firstin=1&off=1&TYPEK=sii&year=103&season=01




# cl <- makeCluster(3)
# 
# clusterExport(cl, "stats")
# clusterExport(cl, "k")
# clusterExport(cl, "j")
# a <- NULL
# k <- 1; j <-10
# 
# a <- lapply(c(1, 3, 11), function(x) rvest::html_text(rvest::html_nodes(stats, xpath = paste0('//body//center//center//table//tr//td//table[',k,']//tr[2]//td//table//tr[',j,']//td[',x,']'))))
# 
# a[3]
# system.time(lapply(c(1, 3), function(x) rvest::html_text(rvest::html_nodes(stats, xpath = paste0('//body//center//center//table//tr//td//table[',k,']//tr[2]//td//table//tr[',j,']//td[',x,']'))))   )
# 
# parLapply(cl, c(1, 3, 11),  month_report_revenue(stats,file_name_mon, x) )

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


library(rvest)
stats <- read_html("http://mops.twse.com.tw/nas/t21/sii/t21sc03_108_2_0.html", encoding = 'ISO-8859-1')


tmp <- NULL
df_tmp_j <- NULL
df_tmp_i <- NULL

sh_pe <- NULL
for(k in c(1:3)){
  j <- 3
  repeat{  # for(j in c(3,4,5,6,7,8,9)){
    for(i in c(1:11)){    # for(i in c(1,3,4,5,6,7,8,9,10,11)){
      asd <- html_nodes(stats, xpath = paste0('//body//center//center//table//tr//td//table[',k,']//tr[2]//td//table//tr[',j,']//td[',i,']'))
      if(length(html_text(asd)) == 0){
        tmp[11] <- 0
        break
      } else{
        tmp[i] <- html_text(asd)
      }
    }
    if(tmp[11] == "-"){
      tmp[1] <- as.numeric(gsub(',', replacement = '', tmp[1]))
      for(i in c(3:10)){tmp[i] <- as.numeric(gsub(',', replacement = '', tmp[i]))}
      
      df_tmp_i <- rbind.data.frame(c(tmp[1], tmp[3:10]))
      colnames(df_tmp_i) <- c("1", "2", "3", "4", "5", "6", "7", "8", "9") 
      df_tmp_j <- rbind(df_tmp_j, df_tmp_i) 
    } else{
      break
    }
    cat(j,",",sep = ""); j <- j + 1
  }
  source("func.R"); sh_pe <- show_percet_len(sh_pe, k, c(1:3))
}


file_path_mon <- paste0(getwd(), "/data_MON/")
file_name_mon <- paste0(file_path_mon, "10802",".csv")
if(dir.exists(file_path_mon) == FALSE){dir.create(file_path_mon)}
write.table(df_tmp_j, file = file_name_mon, sep=",", col.names = FALSE,row.names = FALSE, append = FALSE)
rcsv <- read.csv(file_name_mon)
colnames(rcsv) <- c("1", "2", "3", "4", "5", "6", "7", "8", "9") 

#season report
#http://mops.twse.com.tw/mops/web/ajax_t163sb04?encodeURIComponent=1&step=1&firstin=1&off=1&TYPEK=sii&year=103&season=01



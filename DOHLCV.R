#install.packages( c("jsonlite", "lubridate", "quantmod"))
library(quantmod)
library(lubridate)
library(jsonlite)

source("func.R")


####################################yahoo stock####################################
# stockno <- '2330'
# for (stockno in c("2104.TW", "2330.TW", "2441.TW")){
# stocknum <- na.omit(get(getSymbols(stockno, from="2000-01-01" ,to=Sys.Date())))
# #sum(is.na(tw2330))
# chartSeries(stocknum, from="2000-01-01" ,to=Sys.Date(),theme="black")
# 
# ma_20<-runMean(stocknum[,4],n=20)
# ma_60<-runMean(stocknum[,4],n=60)
# addTA(ma_20,on=1,col="yellow")
# addTA(ma_60,on=1,col="white")
# position<-Lag(ifelse(ma_20>ma_60, 1, 0))
# return<-ROC(Cl(stocknum))*position
# return<-return['2007-03-30/2013-12-31']
# return<-exp(cumsum(return))
# plot(return)
# addBBands()
# addBBands(draw="p")
# }


##################################### TWSE ###########################################
# qdate <- '20170721'   
# qtype <- 'ALLBUT0999' 
# url <- paste0('http://www.twse.com.tw/exchangeReport/MI_INDEX?',
#               'response=json&date=',qdate,'&type=',qtype,'&_=',ttime)
# url_2 <- paste0('http://mops.twse.com.tw/mops/web/t05st22')



###############update_DOHLCV <- function(x) {############################
update_DOHLCV <- function(date_set, stock_n_list, file_path) {
  # file_path <- paste0(getwd(), "/data_DOHLCV/")
  # stockno <- c("2330")
  # date_1 <- c("20000101")
  sh_pee <- NULL
  for(stockno in stock_n_list){
    cat("  Doing stockno", stockno, "\n")
    ttime <- as.character(as.integer(as.POSIXct(Sys.time()))*100)
    historyStock <- NULL
    sh_pe <- NULL
    
    for(date_1 in date_set){
      Sys.sleep(runif(1,2,4))#randomly delay 1 time between 2 and 3 seconds 
      url_1 <- paste0('http://www.tse.com.tw/exchangeReport/STOCK_DAY?',
                     'response=json&date=',date_1,'&stockNo=',stockno,'&_=',ttime)
      jsondata <- fromJSON(url_1)
      if(jsondata$stat == "OK"){
        tmpStock <- data.frame(jsondata$data[, 1],  
                               jsondata$data[, 4:7],  
                               jsondata$data[, 2:3],     
                               stringsAsFactors = FALSE)
        historyStock <- rbind(historyStock, tmpStock) 
      }
      source("func.R"); sh_pe <- show_percet_len(sh_pe, date_1, date_set)
    }
    
    colnames(historyStock) <- c("Date", "Open", "High", "Low", "Close", "Volume", "Value")         
    source("func.R"); historyStock$Date <- year_change_108_to_2019( as.Date(historyStock[, 1]) )
    historyStock$Open <- as.numeric(gsub(',', replacement = '', historyStock$Open))         
    historyStock$High <- as.numeric(gsub(',', replacement = '', historyStock$High))         
    historyStock$Low <- as.numeric(gsub(',', replacement = '', historyStock$Low))         
    historyStock$Close <- as.numeric(gsub(',', replacement = '', historyStock$Close))         
    historyStock$Volume <- as.numeric(gsub(',', replacement = '', historyStock$Volume))         
    historyStock$Value <- as.numeric(gsub(',', replacement = '', historyStock$Value))      
    historyStock <- na.omit(historyStock)
    stock_data <- xts(historyStock[, -1], order.by = as.Date(historyStock[, 1])) 
    
    file_name <- paste0(file_path, stockno,".csv")
    if(file.exists(file_name)){
      ############### read files ############################
      source("func.R"); rcsv_xts <- read_csv_to_xts(file_name)

      ############### update files ############################
      source("func.R"); update_rcsv <- xts_update(rcsv_xts, stock_data, historyStock)
      
      ############### write files ############################
      # write.zoo(update_rcsv, file = file_name, sep=",")
      sink(file = file_name, append = TRUE)
      write.table(update_rcsv, file = file_name, sep=",", row.names = FALSE, col.names = FALSE,append = TRUE)
      sink()
      
    } else{
      ############### write files ############################
      # write.zoo(stock_data, file = file_name, sep=",")
      sink(file = file_name, append = FALSE)
      write.table(historyStock, file = file_name, sep=",", row.names = FALSE, append = FALSE)
      sink()
    }
    
    source("func.R"); sh_pee <- show_percet_len(sh_pee, stockno, stock_n_list)
  }
  rm(sh_pee, stockno, sh_pe, stock_data, file_name)
  rm(tmpStock, jsondata, date_1, ttime, url_1, historyStock)
  cat("All Done\n")
}
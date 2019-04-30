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


# date_1 <- '20190428'
stockno <- '2330'
startyear <- 2018
ttime <- as.character(as.integer(as.POSIXct(Sys.time()))*100)
source("func.R"); date_set_all <- date_set_all(startyear)
historyStock <- NULL
Len <- 1/length(date_set_all)
for(date_1 in date_set_all ){
  Sys.sleep(runif(1,2,3))#randomly delay 1 time between 2 and 3 seconds 
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
  if( round(Len*100) < round((Len + 1/length(date_set_all)[1])*100) ){
    cat(">>>",round(Len*100),"%",sep = "") 
  }  
  Len <- Len + 1/length(date_set_all)
}
cat("\nGet",length(date_set_all),"months\n")
colnames(historyStock) <- c("Date", "Open", "High", "Low", "Close", "Volume", "Value")         
source("func.R"); historyStock$Date <- year_change_108_to_2019( as.Date(historyStock[, 1]) )
historyStock$Open <- as.numeric(gsub(',', replacement = '', historyStock$Open))         
historyStock$High <- as.numeric(gsub(',', replacement = '', historyStock$High))         
historyStock$Low <- as.numeric(gsub(',', replacement = '', historyStock$Low))         
historyStock$Close <- as.numeric(gsub(',', replacement = '', historyStock$Close))         
historyStock$Volume <- as.numeric(gsub(',', replacement = '', historyStock$Volume))         
historyStock$Value <- as.numeric(gsub(',', replacement = '', historyStock$Value))      
historyStock <- na.omit(historyStock)
# data frame to xts         
stock_data <- xts(historyStock[, -1], order.by = as.Date(historyStock[, 1])) 
rm(tmpStock, jsondata, date_1, Len, startyear, ttime, url_1, historyStock)
#chartSeries(stock_data)



file_path <- paste0(getwd(), "/data/", stockno,".csv")
############### write files ############################
write.zoo(stock_data, file = file_path, sep=",")

############### read files ############################
source("func.R"); rcsv <- read_csv_to_xts(file_path)
# chartSeries(rcsv)

############### update files ############################
source("func.R"); update_rcsv <- xts_update(rcsv, stock_data)
write.zoo(update_rcsv, file = file_path, sep=",")
# chartSeries(update_rcsv)


source("func.R"); stock_n_list <- get_stock_num_list("20190417")#openn day

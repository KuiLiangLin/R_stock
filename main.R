#install.packages quantmod
library(quantmod)
#install.packages tidyverse
library(lubridate)# for year 2019 <-> 108
#install.packages jsonlite
library(jsonlite)# for url json format

source("func.R")

stocknum = na.omit(get(getSymbols("2330.TW", from="2000-01-01" ,to=Sys.Date())))
#sum(is.na(tw2330))

chartSeries(stocknum, from="2000-01-01" ,to=Sys.Date(),theme="black")

ma_20<-runMean(stocknum[,4],n=20)
ma_60<-runMean(stocknum[,4],n=60)
addTA(ma_20,on=1,col="yellow")
addTA(ma_60,on=1,col="white")
position<-Lag(ifelse(ma_20>ma_60, 1, 0))
return<-ROC(Cl(stocknum))*position
return<-return['2007-03-30/2013-12-31']
return<-exp(cumsum(return))
plot(return)
addBBands()
addBBands(draw="p")




qdate <- '20170721'   
qtype <- 'ALLBUT0999' 
ttime <- as.character(as.integer(as.POSIXct(Sys.time()))*100)
url <- paste0('http://www.twse.com.tw/exchangeReport/MI_INDEX?',
              'response=json&date=',qdate,'&type=',qtype,'&_=',ttime)

x <- fromJSON(url,flatten=T)
x$data5


url_2 <- paste0('http://mops.twse.com.tw/mops/web/t05st22')

date_1 <- '20190428'
stockno <- '2330'

url_1 <- paste0('http://www.tse.com.tw/exchangeReport/STOCK_DAY?',
               'response=json&date=',date_1,'&stockNo=',stockno,'&_=',ttime)
jsondata <- fromJSON(url_1)

historyStock <- NULL
if(jsondata$stat == "OK"){
  tmpStock <- data.frame(jsondata$data[, 1],  
                         jsondata$data[, 4:7],  
                         jsondata$data[, 2:3],     
                         stringsAsFactors = FALSE)
  historyStock <- rbind(historyStock, tmpStock) 
}


colnames(historyStock) <- c("Date", "Open", "High", "Low", "Close", "Volume", "Value")         
#historyStock$Date <- sapply(historyStock$Date, CNV_DATE)         
historyStock$Date <- year_change_108_to_2019( as.Date(historyStock[, 1]) )
historyStock$Open <- as.numeric(gsub(',', replacement = '', historyStock$Open))         
historyStock$High <- as.numeric(gsub(',', replacement = '', historyStock$High))         
historyStock$Low <- as.numeric(gsub(',', replacement = '', historyStock$Low))         
historyStock$Close <- as.numeric(gsub(',', replacement = '', historyStock$Close))         
historyStock$Volume <- as.numeric(gsub(',', replacement = '', historyStock$Volume))         
historyStock$Value <- as.numeric(gsub(',', replacement = '', historyStock$Value))         
# data frame to xts         
historyStock_1 <- xts(historyStock[, -1], order.by = as.Date(historyStock[, 1])) 
chartSeries(historyStock_1)



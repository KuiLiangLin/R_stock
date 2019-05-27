#install.packages( c("jsonlite", "lubridate", "quantmod"))
library(quantmod)
library(lubridate)
library(jsonlite)
library(rvest)
library(magrittr)

#------------------------------------daily data DOHLCV ----------------------------------------------
 source("func.R"); stock_list <- get_stock_num_list("20190429")
 source("func.R"); date_set <- get_date_set_all(2010)

 file_path <- paste0(getwd(), "/data_DOHLCV/")
 # file_name <- paste0(file_path, stock_list[4],".csv")
 if(dir.exists(file_path) == FALSE){ dir.create(file_path)}
 # source("DOHLCV.R"); update_DOHLCV(date_set[1:4], stock_list[1:4], file_path)
 source("DOHLCV.R"); update_DOHLCV_simplify(date_set[1:12], stock_list[1:20], file_path)
 
 # source("func.R"); rcsv_xts <- read_csv_to_xts(file_name)


 
 
#------------------------------------month report revenue ----------------------------------------------
 for(y in c(108:108)){#99~108
  for(mo in c(4:4)){#1~12
    cat(y,mo)
    Sys.sleep(runif(1,2,4))#randomly delay 1 time between 2 and 3 seconds 
    if(mo <= 9){file_name_mon <- paste0(y,"0",mo)}else{file_name_mon <- paste0(y,mo)}
    source("MON_REV.R"); month_report_revenue(file_name_mon, y, mo)
  }         
 }
 
#------------------------------------month report revenue only for 10201 ----------------------------------------------
 # tmp2 <- NULL
 # file_name_mon <- "10201"
 # file_path_mon <- paste0(getwd(), "/data_MON/")
 # file_name_mon_wr <- paste0(file_path_mon, file_name_mon,".csv")
 # rcsv <- read.csv(file_name_mon_wr)
 # for(x in c(1:808)){
 #   ppp<- strsplit(   as.character(rcsv[x,2]), "<")
 #   tmp <- cbind(as.character(rcsv[x,1]), ppp[[1]][1])
 #   tmp2 <- rbind(tmp2, tmp)
 #  }
 # write.table(tmp2, file = file_name_mon_wr, sep=",",row.names = FALSE, append = FALSE)
 # cat("All Done\n")
 # 
 # 
 

 
 
 
#------------------------------------season report ----------------------------------------------
for(y in c(108:108)){#99~108
  for(z in c(1:1)){#1~4
    cat(paste0(";",y,"0",z))
    Sys.sleep(runif(1,3,4))#randomly delay 1 time between 2 and 3 seconds 
    file_name_season <- paste0(y,"0",z)
    source("SEASON_EPS.R");season_report_eps(file_name_season, y, z) 
  }
}
rcsv <- read.csv(file_name_mon)





#------------------------------------eps estimate season-----------------------
rcsv <- NULL
for(y in c(99:99)){#99~108
  for(z in c(1:1)){#1~4
    file_name_wr <- paste0(paste0(getwd(), "/data_SEASON/"), paste0(y,"0",z),".csv")
    rcsv_tmp <- read.csv(file_name_wr)
    # rcsv <- rbind(rcsv, rcsv_tmp[1:length(rcsv_tmp$V1),1:20])
    # tmp_sea <- as.character(rcsv$V1[1]);tmp_sea
    
    cat(y,z,";")
  }
}    
    rcsv_tmp%<>%t%>%t
    a <- cbind(
       rcsv_tmp[-1, grepl("公司代號",rcsv_tmp[1,])] # stock no
      ,rcsv_tmp[-1, grepl("營業收入",rcsv_tmp[1,])] # operating revenue
      ,rcsv_tmp[-1, grepl("營業成本",rcsv_tmp[1,])] # operating costs
      ,rcsv_tmp[-1, grepl("營業毛利",rcsv_tmp[1,])] # operating gross profit
      ,rcsv_tmp[-1, grepl("營業費用",rcsv_tmp[1,])] # operating expenses
      ,rcsv_tmp[-1, grepl("營業淨利",rcsv_tmp[1,])] # operating net profit
      ,rcsv_tmp[-1, grepl("營業外收入及利益",rcsv_tmp[1,])] # not operating revenue
      ,rcsv_tmp[-1, grepl("營業外費用及損失",rcsv_tmp[1,])] # not operating expenses
      ,rcsv_tmp[-1, grepl("本期淨利",rcsv_tmp[1,])] # income after tax
      ,rcsv_tmp[-1, grepl("基本每股盈餘",rcsv_tmp[1,])] # eps
    )
#    colnames(a) <- c("公司代號","營業收入","營業成本","營業毛利","營業費用","營業淨利",
#                     "營業外收入及利益","營業外費用及損失","本期淨利","基本每股盈餘")
    colnames(a) <- c("stock","revenue","costs","gross profit","expenses","net profit",
                     "not operating revenue","not operating expenses","income after tax","eps")
    a[-1, grepl("stock no",colnames(a))]
    a%<>%t
    b <- a[,grepl("1101",a[1,])] %>% cbind
    
    
    
    
    

x <- array(NA, c(dim(rcsv_mon),7))
x[,,1] <- a


#------------------------------------eps estimate month-----------------------
source("estimate.R");   monthly_all <- monthly_data_fecth(108)

for(x_name in c(stock_list[1:4])){
  monthly_data <- xts(as.numeric(monthly_all[-1,grepl(x_name,monthly_all[1,])]), order.by = as.Date(as.numeric(monthly_all[-1,1])))
  chartSeries(monthly_data, name = monthly_all[1,grepl(x_name,monthly_all[1,])],theme="black")
}
# 
# library(rJava)
# library(xlsx)#need to download java
# install.packages('xlsx')
# write.xlsx(dataframe1, file="filename.xlsx", sheetName="sheet1")
# write.xlsx(dataframe2, file="filename.xlsx", sheetName="sheet2", append=TRUE)
# 
# Sys.setenv(JAVA_HOME='D:\\Java\\jdk-12.0.1')
# 
# library(XLConnect)
# install.packages("XLConnect")
# loadWorkbook(file_name)
# getSheets(file_name)
# writeWorksheet(workbook, data, worksheet)
# saveWorkbook(workbook, name of new workbook)





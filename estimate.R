monthly_data_fecth <- function(yearr) {
  yearr <- 108
  rcsv <- NULL

  for(y in c(100:yearr)){#99~108
    for(mo in c(1:12)){#1~4
      if(mo <= 9){file_name_mon <- paste0(y,"0",mo)}else{file_name_mon <- paste0(y,mo)}
      file_name_wr <- paste0(paste0(getwd(), "/data_MON/"), file_name_mon,".csv")
      if(file.exists(file_name_wr)){
      rcsv_tmp <- read.csv(file_name_wr)
      rcsv_tmp <- rcsv_tmp[!duplicated(rcsv_tmp),]
      colnames(rcsv_tmp) <- c("no", paste0(file_name_mon, "01"))
      if(is.null(rcsv)){rcsv <- rcsv_tmp}else{rcsv <- merge(rcsv_tmp, rcsv, by="no", all = TRUE)}
      cat(y,mo,";")
      } else {break}
    }
  }

  rcsv_mon <- rcsv; 
  rcsv_mon[length(rcsv_mon[,1]),1] <- "Total"
  for(x in c(2:length(rcsv_mon[1,]))){
    bbb<-rcsv_mon[,x]
    rcsv_mon[length(rcsv_mon[,x]),x] <- sum(bbb[!is.na(bbb)])
  }
  a <- t(rcsv_mon)
  a[is.na(a)] <- 0
  a[,1] <- as.numeric(row.names(a))
  source("func.R"); a[-1,1] <- year_change_108_to_2019(as.numeric(a[-1,1]) )
  # b <- a[-1,grepl("1101",a[1,])]
  # monthly_data <- xts(as.numeric(a[-1,grepl("Total",a[1,])]), order.by = as.Date(as.numeric(a[-1,1])))
  # chartSeries(monthly_data, name = a[1,grepl("Total",a[1,])],theme="black")
  return(a)
  rm(rcsv_tmp, file_name_mon, file_name_wr, mo, y, rcsv, a, bbb, rcsv_mon, x)
}

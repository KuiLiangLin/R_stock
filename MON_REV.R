#install.packages( c("jsonlite", "lubridate", "quantmod"))
library(rvest)
library(compiler)
#stats <- read_html("http://mops.twse.com.tw/nas/t21/sii/t21sc03_108_2_0.html", encoding = 'ISO-8859-1')
# file_name_mon <- "10802"

month_report_revenue <- function(stats, file_name_mon, k) {
  cmpfun(asdd)
  tmp <- 1:11;  df_tmp_j <- NULL;  df_tmp_i <- NULL;  sh_pe <- NULL
  for(k in c(1:2)){
    j <- 3
    repeat{  # for(j in c(3,4,5,6,7,8,9)){
      for(i in c(1,3,11)){    # for(i in c(1,3,4,5,6,7,8,9,10,11)){
        asd <- html_nodes(stats, xpath = paste0('//body//center//center//table//tr//td//table[',k,']//tr[2]//td//table//tr[',j,']//td[',i,']'))
        if(length(asdd(asd)) == 0){
          tmp[11] <- 0
          break
        } else{
          tmp[i] <- asdd(asd)
        }
      }
      if(tmp[11] == 0){
        break
      } else{
      for(i in c(1,3)){tmp[i] <- as.numeric(gsub(',', replacement = '', tmp[i]))}
      df_tmp_i <- rbind.data.frame(c(tmp[1], tmp[3]))
      colnames(df_tmp_i) <- c("num", "revenue")
      df_tmp_j <- rbind(df_tmp_j, df_tmp_i)
      }
      cat(j,",",sep = ""); j <- j + 1
    }
    source("func.R"); sh_pe <- show_percet_len(sh_pe, k, c(1:2))
  }
  
  file_path_mon <- paste0(getwd(), "/data_MON/")
  file_name_mon_wr <- paste0(file_path_mon, file_name_mon,".csv")
  if(dir.exists(file_path_mon) == FALSE){dir.create(file_path_mon)}
  write.table(df_tmp_j, file = file_name_mon_wr, sep=",",row.names = FALSE, append = FALSE)
  cat("All Done\n")
}


asdd <- function(x){
  asddd <- html_text(x)
  return(asddd)
}

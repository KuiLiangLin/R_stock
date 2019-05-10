#install.packages( c("jsonlite", "lubridate", "quantmod"))
library(quantmod)
library(lubridate)
library(jsonlite)
library(compiler)
library(rvest)
source("func.R")
source("DOHLCV.R")

# stats <- read_html("http://mops.twse.com.tw/nas/t21/sii/t21sc03_108_1_0.html", encoding = 'ISO-8859-1')
source("fork_MON_REV_main.R")


# cmpfun(asdd)
tmp <- 1:11;  df_tmp_j <- NULL;  df_tmp_i <- NULL;
for(k in c(20:29)){
  cat(" %%k=",k,"%% ",sep = "");
  j <- 3
  repeat{  # for(j in c(3,4,5,6,7,8,9)){
    for(i in c(1,3,11)){    # for(i in c(1,3,4,5,6,7,8,9,10,11)){
      asd <- html_nodes(stats, xpath = paste0('//body//center//center//table//tr//td//table[',k,']//tr[2]//td//table//tr[',j,']//td[',i,']'))
      if(length(html_text(asd)) == 0){
        tmp[11] <- 0
        break
      } else{
        tmp[i] <- html_text(asd)
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
}
out_3 <- df_tmp_j
rm(tmp, df_tmp_j, df_tmp_i, i, k, j, asd)
cat("All Done\n")






#install.packages( c("jsonlite", "lubridate", "quantmod"))
library(rvest)
# library(compiler)
#stats <- read_html("http://mops.twse.com.tw/nas/t21/sii/t21sc03_108_2_0.html", encoding = 'ISO-8859-1')
# file_name_mon <- "10802"

month_report_revenue_1 <- function(file_name_mon, y, mo) {
  y <- 105
  mo <- 10
  url <- paste0("http://mops.twse.com.tw/nas/t21/sii/t21sc03_",y,"_",mo,"_0.html")
  # stats <- read_html("http://mops.twse.com.tw/nas/t21/sii/t21sc03_108_1_0.html", encoding = 'ISO-8859-1')
  # file_name_mon <- "10803"
  stats <- read_html(url, encoding = 'ISO-8859-1')
  sh_pe <- NULL
  f1 <- NULL
  for(m in c(1:28)){
     # m <- 4
     # aaa <- html_text(html_nodes(stats, xpath = paste0('//body//center//center//table//tr//td//table[',m,']//tr[2]//td//table//tr')))
    aaa <- html_text(html_nodes(stats, xpath = paste0('//body//center//center//table//tr//td//table[',m,']//tr[2]//td//table')))
    aaa <- gsub(',', replacement = '', aaa)
    # d <- substring(aaa, 138, 141)
    bbb <- strsplit(aaa, "    ")
    d <- NULL
    #-----------------------------get all number--------------------------------
    for(i in c(1:length(bbb[[1]]))){
      c <- grep("[0-9]", bbb[[1]][i], value = TRUE)
      if(length(c)==1){d <- cbind(d, c)}
    }
    d[1] <- substring(d[1], 139, 142)
    #-----------------------------get stock number--------------------------------
    zero_shift <- 0
    f <- c(d[1], d[2])
    for(j in c(0:ceiling((length(d)-25)/8))){
      r1 <- strsplit(d[9+8*j-zero_shift], "")
      cc <- cbind(NA, NA, NA, NA)
      if(gsub(' ', replacement = '', d[9+8*j+3-zero_shift]) == "0"){
        if(substring(gsub(' ', replacement = '', d[9+8*j+6-zero_shift]),1,1) == "0"){
          zero_shift <- zero_shift + 2
        }else{
          zero_shift <- zero_shift + 1
        }
        cat("Discard revenue of a stock number")
      }else{
        for(x in c( ceiling(length(r1[[1]])) :1 )){
          c <- grep("[0-9]", r1[[1]][x], value = TRUE)
          if(length(c)==1){
            cc[4] <- cc[3]
            cc[3] <- cc[2]
            cc[2] <- cc[1]
            cc[1] <- c
            if(is.na(cc[4])==FALSE){break}
          }
        }
        d[9+8*j-zero_shift] <- paste0(cc[1], cc[2], cc[3], cc[4])
        f <- rbind(f, c(d[9+8*j-zero_shift], d[9+8*j-zero_shift+1]) )
      }
    }
    # f <- c(d[1], d[2])
    # for(k in c(1:ceiling((length(d)-17)/8))){
    #   f <- rbind(f, c(d[1+8*k], d[2+8*k]) )
    # }
    f1 <- rbind(f1, f)
    source("func.R"); sh_pe <- show_percet_len(sh_pe, m, c(1:28))
  }
  
  # 
  # cmpfun(asdd)
  # tmp <- 1:11;  df_tmp_j <- NULL;  df_tmp_i <- NULL;  sh_pe <- NULL
  # for(k in c(1:2)){
  #   j <- 3
  #   repeat{  # for(j in c(3,4,5,6,7,8,9)){
  #     for(i in c(1,3,11)){    # for(i in c(1,3,4,5,6,7,8,9,10,11)){
  #       asd <- html_nodes(stats, xpath = paste0('//body//center//center//table//tr//td//table[',k,']//tr[2]//td//table//tr[',j,']//td[',i,']'))
  #       if(length(asdd(asd)) == 0){
  #         tmp[11] <- 0
  #         break
  #       } else{
  #         tmp[i] <- asdd(asd)
  #       }
  #     }
  #     if(tmp[11] == 0){
  #       break
  #     } else{
  #     for(i in c(1,3)){tmp[i] <- as.numeric(gsub(',', replacement = '', tmp[i]))}
  #     df_tmp_i <- rbind.data.frame(c(tmp[1], tmp[3]))
  #     colnames(df_tmp_i) <- c("num", "revenue")
  #     df_tmp_j <- rbind(df_tmp_j, df_tmp_i)
  #     }
  #     cat(j,",",sep = ""); j <- j + 1
  #   }
  #   source("func.R"); sh_pe <- show_percet_len(sh_pe, k, c(1:2))
  # }
  
  file_path_mon <- paste0(getwd(), "/data_MON/")
  file_name_mon_wr <- paste0(file_path_mon, file_name_mon,".csv")
  if(dir.exists(file_path_mon) == FALSE){dir.create(file_path_mon)}
  write.table(f1, file = file_name_mon_wr, sep=",",row.names = FALSE, append = FALSE)
  cat("All Done\n")
}

# 
# asdd <- function(x){
#   asddd <- html_text(x)
#   return(asddd)
# }



month_report_revenue <- function(file_name_mon, y, mo) {
  # y <- 105
  # mo <- 10
  url <- paste0("http://mops.twse.com.tw/nas/t21/sii/t21sc03_",y,"_",mo,"_0.html")
  # stats <- read_html("http://mops.twse.com.tw/nas/t21/sii/t21sc03_108_1_0.html", encoding = 'ISO-8859-1')
  # file_name_mon <- "10803"
  stats <- read_html(url, encoding = 'ISO-8859-1')

  sh_pe <- NULL
  f1 <- NULL
  for(m in c(1:28)){
    # m <- 4
    aaa <- html_text(html_nodes(stats, xpath = paste0('//body//center//center//table//tr//td//table[',m,']//tr[2]//td//table//tr')))
    for(x in c(3:(length(aaa)-1) )){
      cc <- substring(aaa[x], 1, 4)
      aaaa <- strsplit(aaa[x], "    ")
      for(i in c(2:length(aaaa[[1]]))){
        ccc <- grep("[0-9]", aaaa[[1]][i], value = TRUE)
        if(length(ccc)==1){
          ccc <- gsub(',', replacement = '', aaaa[[1]][i])
          ccc <- gsub(' ', replacement = '', ccc)
          f1 <- rbind(f, c(cc, ccc) )
          break
        }
      }
    }
    source("func.R"); sh_pe <- show_percet_len(sh_pe, m, c(1:28))
  }
  file_path_mon <- paste0(getwd(), "/data_MON/")
  file_name_mon_wr <- paste0(file_path_mon, file_name_mon,".csv")
  if(dir.exists(file_path_mon) == FALSE){dir.create(file_path_mon)}
  write.table(f1, file = file_name_mon_wr, sep=",",row.names = FALSE, append = FALSE)
  cat("All Done\n")
}
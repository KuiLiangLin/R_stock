#install.packages( c("jsonlite", "lubridate", "quantmod"))
library(rvest)
# library(compiler)
#stats <- read_html("http://mops.twse.com.tw/nas/t21/sii/t21sc03_108_2_0.html", encoding = 'ISO-8859-1')
# file_name_mon <- "10802"
# 

month_report_revenue <- function(file_name_mon, y, mo) {
  # y <- 99
  # mo <- 10
  url <- paste0("http://mops.twse.com.tw/nas/t21/sii/t21sc03_",y,"_",mo,"_0.html")
  # stats <- read_html("http://mops.twse.com.tw/nas/t21/sii/t21sc03_99_1_0.html", encoding = 'ISO-8859-1')
  # stats <- read_html("http://mops.twse.com.tw/nas/t21/sii/t21sc03_108_1_0.html", encoding = 'ISO-8859-1')
  # file_name_mon <- "10803"
  stats <- read_html(url, encoding = 'ISO-8859-1')
  
  sh_pe <- NULL
  f1 <- NULL
  if(y=="100" | y=="99"){cm <- c(1:30)}else{cm <- c(1:28)}
  for(m in cm){
    # m <- 1
    if(y=="100" | y=="99"){
      aaa <- html_text(html_nodes(stats, xpath = paste0('//body//center//center//table[',m+1,']//tr[2]//td//table//tr')))
    }else if(y=="102" & mo == "1"){
      aaa <- html_text(html_nodes(stats, xpath = paste0('//body//center//center//table//tr//td//table[',m,']//tr[3]//td//table//tr')))
    }else{
      aaa <- html_text(html_nodes(stats, xpath = paste0('//body//center//center//table//tr//td//table[',m,']//tr[2]//td//table//tr')))
    }
    for(x in c(3:(length(aaa)-1) )){
      cc <- substring(aaa[x], 1, 4)
      aaaa <- strsplit(aaa[x], "    ")
      for(i in c(2:length(aaaa[[1]]))){
        ccc <- grep("[0-9]", aaaa[[1]][i], value = TRUE)
        if(length(ccc)==1){
          ccc <- gsub(',', replacement = '', aaaa[[1]][i])
          ccc <- gsub(' ', replacement = '', ccc)
          f1 <- rbind(f1, c(cc, ccc) )
          break
        }
      }
    }
    source("func.R"); sh_pe <- show_percet_len(sh_pe, m, cm)
  }
  file_path_mon <- paste0(getwd(), "/data_MON/")
  file_name_mon_wr <- paste0(file_path_mon, file_name_mon,".csv")
  if(dir.exists(file_path_mon) == FALSE){dir.create(file_path_mon)}
  write.table(f1, file = file_name_mon_wr, sep=",",row.names = FALSE, append = FALSE)
  cat("All Done\n")
}
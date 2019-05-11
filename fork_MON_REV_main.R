#install.packages( c("jsonlite", "lubridate", "quantmod"))
library(quantmod)
library(lubridate)
library(rvest)



stats <- read_html("http://mops.twse.com.tw/nas/t21/sii/t21sc03_107_12_0.html", encoding = 'ISO-8859-1')
# do fork job
# do fork job
# do fork job
# do fork job
out_1 <- NULL
out_2 <- NULL
out_3 <- NULL
df_tmp <- rbind(out_1, out_2, out_3)
file_name_mon <- "10712"
file_path_mon <- paste0(getwd(), "/data_MON/")
file_name_mon_wr <- paste0(file_path_mon, file_name_mon,".csv")
if(dir.exists(file_path_mon) == FALSE){dir.create(file_path_mon)}
write.table(df_tmp, file = file_name_mon_wr, sep=",",row.names = FALSE, append = FALSE)


f1 <- NULL
for(m in c(1:28)){
  # m <- 4
  aaa <- html_text(html_nodes(stats, xpath = paste0('//body//center//center//table//tr//td//table[',m,']//tr[2]//td//table')))
  aaa <- gsub(',', replacement = '', aaa)
  # d <- substring(aaa, 138, 141)
  bbb <- strsplit(aaa, "    ")
  d <- NULL
  for(i in c(1:length(bbb[[1]]))){
    c <- grep("[0-9]", bbb[[1]][i], value = TRUE)
    if(length(c)==1){d <- cbind(d, c)}
  }
  d[1] <- substring(d[1], 139, 142)
  for(j in c(0:ceiling((length(d)-25)/8))){
    # d[9+8*j] <- last(strsplit(d[9+8*j], "-")[[1]])
    # d[9+8*j] <- substring(d[9+8*j], 1, 4)
    r1 <- strsplit(d[9+8*j], "")
    cc <- cbind(NA, NA, NA, NA)
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
    d[9+8*j] <- paste0(cc[1], cc[2], cc[3], cc[4])
  }
  f <- c(d[1], d[2])
  for(k in c(1:ceiling((length(d)-17)/8))){
    f <- rbind(f, c(d[1+8*k], d[2+8*k]) )
  }
  f1 <- rbind(f1, f)
  print(m)
}




# 
# 
# 
# c(d[1], d[2])
# d[9]
# d[17]
# r <- strsplit(aaa, "       ")
# r[[1]][192]
# r1 <- strsplit(r[[1]][192], "")
# 
# r1 <- strsplit(d[9+8*j], "")
# cc <- cbind(NA, NA, NA, NA)
# for(x in c(length(r1[[1]]):1)){
# c <- grep("[0-9]", r1[[1]][x], value = TRUE)
# if(length(c)==1){
#   cc[4] <- cc[3]
#   cc[3] <- cc[2]
#   cc[2] <- cc[1]
#   cc[1] <- c
#   if(is.na(cc[4])==FALSE){break}
#   }
# }
# d[9+8*j] <- paste0(cc[1], cc[2], cc[3], cc[4])

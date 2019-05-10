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


# 
# aaa <- html_text(html_nodes(stats, xpath = paste0('//body//center//center//table//tr//td//table[1]//tr[2]//td//table')))
# aaa <- gsub(',', replacement = '', aaa)
# substring(aaa, 139, 142)
# bbb <- strsplit(aaa, " ")
# for(i in c(1:1000)){
#   is.numeric(bbb[[1]][988])
# }
# 


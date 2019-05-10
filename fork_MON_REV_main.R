#install.packages( c("jsonlite", "lubridate", "quantmod"))
library(quantmod)
library(lubridate)
library(rvest)



stats <- read_html("http://mops.twse.com.tw/nas/t21/sii/t21sc03_107_12_0.html", encoding = 'ISO-8859-1')
# do fork job
# do fork job
# do fork job
# do fork job
df_tmp_j <- NULL
file_name_mon <- "10712"
file_path_mon <- paste0(getwd(), "/data_MON/")
file_name_mon_wr <- paste0(file_path_mon, file_name_mon,".csv")
if(dir.exists(file_path_mon) == FALSE){dir.create(file_path_mon)}
write.table(df_tmp_j, file = file_name_mon_wr, sep=",",row.names = FALSE, append = FALSE)
out_1 <- NULL

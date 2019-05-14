library(rvest)

season_report_eps <- function(file_name_season, y, z) {
  # y <- 99
  # http://mops.twse.com.tw/mops/web/ajax_t51sb08?encodeURIComponent=1&step=1&firstin=1&off=1&TYPEK=sii&year=101&season=01
  #"http://mops.twse.com.tw/mops/web/ajax_t163sb04?encodeURIComponent=1&step=1&firstin=1&off=1&TYPEK=sii&year=106&season=01"
  # url <- paste0("http://mops.twse.com.tw/mops/web/ajax_t163sb04?encodeURIComponent=1&step=1&firstin=1&off=1&TYPEK=sii&year=",y,"&season=0",z)
  if(y=='101' | y=='100' | y=='99'){ # year < 102
    url <- paste0("http://mops.twse.com.tw/mops/web/ajax_t51sb08?encodeURIComponent=1&step=1&firstin=1&off=1&TYPEK=sii&year=",y,"&season=0",z)
  }else{
    url <- paste0("http://mops.twse.com.tw/mops/web/ajax_t163sb04?encodeURIComponent=1&step=1&firstin=1&off=1&TYPEK=sii&year=",y,"&season=0",z)
  }
  stats <- read_html(url, encoding = 'utf-8')
  

  if(y=='101' | y=='100' | y=='99'){ # year < 102
    f <- html_text(html_nodes(stats, xpath = paste0('//body//center[3]//table//tr[1]')))
  }else{
    f <- html_text(html_nodes(stats, xpath = paste0('//body//table[3]//tr[1]//th')))
  }
  
  for(x in c(2:2000)){
    if(y=='101' | y=='100' | y=='99'){ # year < 102
      aaa <- html_text(html_nodes(stats, xpath = paste0('//body//center[3]//table//tr[',x,']')))
    }else{
      aaa <- html_text(html_nodes(stats, xpath = paste0('//body//table[3]//tr[',x,']//td')))
    }
    
    if(length(aaa)==0){cat("Get",x,"data ");break}
    f <- rbind(f, aaa )
  }
  file_path_season <- paste0(getwd(), "/data_SEASON/")
  # file_name_season <- paste0(y,"0",z)
  file_name_season_wr <- paste0(file_path_season, file_name_season,".csv")
  if(dir.exists(file_path_season) == FALSE){dir.create(file_path_season)}
  write.table(f, file = file_name_season_wr, sep=",",row.names = FALSE, append = FALSE)
}



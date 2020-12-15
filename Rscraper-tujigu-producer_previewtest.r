#install.packages("xml2")
#install.packages("rvest")
#install.packages("downloader")
#install.packages("tidyverse")

Sys.setenv(LANGUAGE = "en")

library(xml2)
library(rvest)
#library(downloader)
library(tidyverse)

baseurl <- "https://www.tujigu.com/x/57/"

# find how many sets of pic
total_sets <- read_html(baseurl) %>% html_nodes(".shoulushuliang span") %>% 
  html_text() %>% as.numeric()

add_page <- c("", str_c("index_", 1:(total_sets %/% 40), ".html"))

main_url <- str_c(baseurl, add_page) %>% as.list()


# counting file quantity, find file group address, prepare all file titles

count_img <- vector("list", length(main_url))
picpath <- vector("list", length(main_url))
title <- vector("list", length(main_url))

for (i in 1:length(main_url)){
  count_img[[i]] <- read_html(main_url[[i]]) %>% html_nodes(".hezi .shuliang") %>% 
    html_text() 
  
  picpath[[i]] <- read_html(main_url[[i]]) %>% html_nodes(".hezi img") %>% 
    html_attr("src")
  
  title[[i]] <- read_html(main_url[[i]]) %>% html_nodes(".biaoti a") %>%
    html_text()
  
}

count_img <- str_c(unlist(count_img))
count_img <- str_replace_all(count_img, "P", "") %>% as.numeric()

picpath <- str_c(unlist(picpath))
# picpath <- str_remove_all(picpath, "0.jpg")

title <- str_c(unlist(title))

title0 <- title

title0 <- str_replace_all(title0, "[/・•､〜♡゙゚｣゚｣ﾏ‼゙ ♥･♪ ?\"\t]", "_")

title0 <- str_replace_all(title0, "[\\\\/:*?\"<>|]", "")

# creating download object dir use page name and regular it 
dirname <- read_html(main_url[[1]]) %>% html_nodes("h1") %>% html_text()
dirname <- str_replace_all(dirname, "[\\\\/:*?\"<>|]", "")

#dirname <- str_replace_all(dirname, ",", "、")
dir.create(paste0("D:/R-projects/img/", dirname))


# loop downloading function
for(l in 1:sum(total_sets)) {
  download.file(picpath[l], sprintf("D:/R-projects/img/%s/%s.jpg", dirname, 
                               title0[l]), quiet = TRUE, mode = "wb")
  #Sys.sleep(0.3)
}


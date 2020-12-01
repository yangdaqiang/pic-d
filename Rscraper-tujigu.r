#install.packages("xml2")
#install.packages("rvest")
#install.packages("downloader")
#install.packages("tidyverse")
Sys.setenv(LANGUAGE = "en")

library(xml2)
library(rvest)
library(downloader)
library(tidyverse)

baseurl <- "https://www.tujigu.com/t/2870/"

# find how many sets of pic
total_sets <- read_html(baseurl) %>% html_nodes(".shoulushuliang span") %>% 
  html_text() %>% as.numeric()

# add condition for different amount of alumb sets
if(total_sets > 40) {
  add_page <- c("", str_c("index_", 1:(total_sets %/% 40), ".html"))
  main_url <- str_c(baseurl, add_page) %>% as.list()
  } else {
  main_url <- baseurl
  } 

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
count_img <- as.numeric(str_replace_all(count_img, "P", ""))

picpath <- str_c(unlist(picpath))
picpath <- str_remove_all(picpath, "0.jpg")

title <- str_c(unlist(title))

# vectorizing each file address by "list" it
url_col <- vector("list", length(picpath))
  for (x in seq_along(picpath)) {
  url_col[[x]] <- sprintf("%s%d.jpg", rep(picpath[[x]], count_img[x]), 
                          1:count_img[x])
}

url_col <- str_c(unlist(url_col))

# creating download object dir use page name and regular it 
dirname <- read_html(main_url[[1]]) %>% html_nodes("div.renwu") %>% 
  html_nodes("div.left") %>% html_nodes("img") %>% html_attr("alt") 
dirname <- str_replace_all(dirname, ",", "、")
dir.create(paste0("D:/R-projects/img/", dirname))

# loop downloading function
for(i in 1:sum(count_img)) {
  download(url_col[i],sprintf("D:/R-projects/img/%s/%05d.jpg", dirname,i), 
           quiet = TRUE, mode = "wb")
}


#install.packages("xml2")
#install.packages("rvest")
#install.packages("downloader")
#install.packages("tidyverse")

library(xml2)
library(rvest)
library(downloader)
library(tidyverse)

baseurl <- "https://www.tujigu.com/x/95/"

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
  count_img[[i]] <- read_html(main_url[[i]]) %>% html_nodes(".shuliang") %>% 
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
dirname <- read_html(main_url[[1]]) %>% html_nodes("h1") %>% html_text()

# dirname <- str_replace_all(dirname, ",", "、")
dir.create(paste0("D:/R-projects/img/", dirname))

# title 
title0 <- title

# file name's trial and error

title0 <- str_replace_all(title0, "[/・､〜｣]", "_")


title_all <- vector("list", length(title))
for (m in seq_along(title)) {
  title_all[[m]] <- sprintf("%s_%03d.jpg", rep(title0[[m]], count_img[m]), 
                            1:count_img[m])
}

title_all <- str_c(unlist(title_all))


# loop downloading function
for(l in 1:sum(count_img)) {
  download(url_col[l], sprintf("D:/R-projects/img/%s/%s", dirname, 
                               title_all[l]), quiet = TRUE, mode = "wb")
}



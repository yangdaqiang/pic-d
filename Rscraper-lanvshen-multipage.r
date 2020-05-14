#install.packages("xml2")
#install.packages("rvest")
#install.packages("downloader")
#install.packages("tidyverse")

library(xml2)
library(rvest)
library(downloader)
library(tidyverse)

baseurl <- "https://www.lanvshen.com/t/459/"

# find how many sets of pic
total_sets <- as.numeric(read_html(baseurl) %>% html_nodes("div.shoulushuliang") %>% 
html_nodes("span") %>% html_text("span"))

add_page <- c("", str_c("index_", 1:(total_sets %/% 40), ".html"))

main_url <- as.list(str_c(baseurl, add_page))

# counting file quantity

count_img <- vector("list", length(main_url))
for (i in 1:length(main_url)){
  count_img[[i]] <- read_html(main_url[[i]]) %>% html_nodes("div.hezi") %>% html_nodes("ul") %>%
  html_nodes("li") %>% html_nodes("span.shuliang") %>% html_text("a") 
}
count_img <- str_c(unlist(count_img))
count_img <- as.numeric(str_replace_all(count_img, "P", ""))

# find file group address
picpath <- vector("list", length(main_url))
for (j in 1:length(main_url)){
picpath[[j]] <- read_html(main_url[[j]]) %>% html_nodes("div.hezi") %>% html_nodes("ul") %>% 
  html_nodes("li") %>% html_nodes("a") %>% html_nodes("img") %>% html_attr("src")
}

picpath <- str_c(unlist(picpath))

# creating file address list 
picpath <- str_remove_all(picpath, "0.jpg")

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
dir.create(paste0("D:/R-projects/pic-d/img/", dirname))

# loop downloading function
for(i in 1:sum(count_img)) {
  download(url_col[i],sprintf("D:/R-projects/pic-d/img/%s/%05d.jpg", dirname,i), 
           quiet = TRUE, mode = "wb")
}



#install.packages("xml2")
#install.packages("rvest")
#install.packages("downloader")
#install.packages("tidyverse")

library(xml2)
library(rvest)
library(downloader)
library(tidyverse)

main_url <- "https://www.tujigu.com/t/1876/" 

# counting file quantity
count_img <- read_html(main_url) %>% html_nodes("div.hezi") %>% html_nodes("ul") %>%
  html_nodes("li") %>% html_nodes("span.shuliang") %>% html_text("a") 

count_img <- as.numeric(str_replace_all(count_img, "P", ""))

# find file group address
picpath <- read_html(main_url) %>% html_nodes("div.hezi") %>% html_nodes("ul") %>% 
  html_nodes("li") %>% html_nodes("a") %>% html_nodes("img") %>% html_attr("src")
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
dirname <- read_html(main_url) %>% html_nodes("div.renwu") %>% 
  html_nodes("div.left") %>% html_nodes("img") %>% html_attr("alt") 
dirname <- str_replace_all(dirname, ",", "、")
dir.create(paste0("D:/R-projects/img/", dirname))

# loop downloading function
for(i in 1:sum(count_img)) {
  download(url_col[i],sprintf("D:/R-projects/img/%s/%04d.jpg", dirname,i), 
           quiet = TRUE, mode = "wb")
}



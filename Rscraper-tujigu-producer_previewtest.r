#install.packages("xml2")
#install.packages("rvest")
#install.packages("downloader")
#install.packages("tidyverse")

library(xml2)
library(rvest)
library(downloader)
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
  count_img[[i]] <- read_html(main_url[[i]]) %>% html_nodes(".shuliang") %>% 
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

title0 <- str_replace_all(title0, c("腿模" = "", "写真集" = "","Beautyleg" = "",  
                                    "美腿" = "", "PhotoBook" = "", "[\\[\\]]" = ""))

title0 <- str_replace_all(title0, c("写真集" = "", "PB" = "","Photobook" = "",  
                                    "Photo Book" = "", "PhotoBook" = "", "[\\[\\]]" = ""))


# title0 <- str_replace_all(title0, "P?k", "")
# title0 <- str_replace_all(title0, "^P?k$", "")
# 
# 
# 
# 
# title0 <- str_replace_all(title0, "^\\[?\\]$", "")
# 
# title0 <- str_replace_all(title0, "[\\[\\]]", "")

title0 <- str_replace_all(title0, "[/・､〜｣]", "_")

# creating download object dir use page name and regular it 
dirname <- read_html(main_url[[1]]) %>% html_nodes("h1") %>% html_text()

#dirname <- str_replace_all(dirname, ",", "、")
dir.create(paste0("D:/R-projects/img/", dirname))


# loop downloading function
for(l in 1:sum(total_sets)) {
  download(picpath[l], sprintf("D:/R-projects/img/%s/%s.jpg", dirname, 
                               title0[l]), quiet = TRUE, mode = "wb")
}

# title <- str_replace_all(title, "/", "_")
# 
# title <- str_replace_all(title, "・", "_")
# 
# title <- str_replace_all(title, "､", "_")

# find file group address
# picpath <- vector("list", length(main_url))
# for (j in 1:length(main_url)){
#   picpath[[j]] <- read_html(main_url[[j]]) %>% html_nodes(".hezi img") %>% 
#     html_attr("src")
# }
# 
# picpath <- str_c(unlist(picpath))

# creating file address list 
# picpath <- str_remove_all(picpath, "0.jpg")


# vectorizing each file address by "list" it

# url_col <- vector("list", length(picpath))
# for (x in seq_along(picpath)) {
#   url_col[[x]] <- sprintf("%s%d.jpg", rep(picpath[[x]], count_img[x]), 
#                           1:count_img[x])
# }
# 
# url_col <- str_c(unlist(url_col))
# 
# 
# title_all <- vector("list", length(title))
# for (m in seq_along(title)) {
#   title_all[[m]] <- sprintf("%s_%03d.jpg", rep(title[[m]], count_img[m]),
#                             1:count_img[m])
# }
# 
# title_all <- str_c(unlist(title_all))





# collecting alumb title
# title <- vector("list", length(main_url))
# for (k in 1:length(main_url)){
#   title[[k]] <- read_html(main_url[[k]]) %>% html_nodes(".biaoti a") %>%
#     html_text()
# }
# title <- str_c(unlist(title))
# 
# title <- str_replace_all(title, "写真集", "")
# 

# 
# title_all <- vector("list", length(title))
# for (m in seq_along(title)) {
#   title_all[[m]] <- sprintf("%s_%03d.jpg", rep(title[[m]], count_img[m]),
#                             1:count_img[m])
# }
# 
# title_all <- str_c(unlist(title_all))



# # loop downloading function
# for(l in 1:sum(count_img)) {
#   download(url_col[l], sprintf("D:/R-projects/img/%s/%s", dirname, 
#                                title_all[l]), quiet = TRUE, mode = "wb")
# }



library(rvest)
brood<- html("http://www.dotabuff.com/players/119721201/matches?date=&hero=broodmother")
brood_table<- html("http://www.dotabuff.com/players/119721201/matches?date=&hero=broodmother") %>% html_table()
brood %>% html_nodes (xpath= '//*[@id="page-content"]/section/article[2]/table/tbody/tr[1]/td[7]/div[1]/a/img')
brood %>% html_nodes(xpath = '//*[@id="page-content"]/section/article[2]/table/tbody/tr[1]/td[7]/div/a/img') %>% html_attr("title")
hi tim! i think you understand github now

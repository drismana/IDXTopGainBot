library(dplyr)
library(rvest)
library(rtweet)
library(mongolite)


### Scrapping the Data 
## URL
url  <- "https://www.idxchannel.com/market-stock"

page <- url %>% read_html() 
data_stock <- data.frame(page %>% html_table()) 
tz <- 7  #WIB+7
data_stock_top10gain <- data_stock %>% arrange(desc(X.)) %>% head(10) %>% mutate (ScrapTime = format(Sys.time() +tz*60*60, "%d-%b-%Y %H:%M:%S"), TweetStatus = 0)%>% rename (Kode=Code, Nama=Name, Sebelumnya = Prev., Penutupan = Close, Selisih = Change, SelisihPersen = X.) %>% select (-No.)
                

## Insert to MongoDb

connection_string = Sys.getenv("MONGO_CONNECT_URI")
top10gain_collection = mongo(collection = Sys.getenv("MONGO_COLLECTION"),
                         db= Sys.getenv("MONGO_DB"),
                         url=connection_string)

top10gain_collection$insert(data_stock_top10gain)

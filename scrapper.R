library(dplyr)
library(mongolite)


### Scrapping the Data 
## URL
url  <- "https://www.idxchannel.com/market-stock"

page <- url %>% read_html() 
data_stock <- data.frame(page %>% html_table()) 
data_stock_top10gain <- data_stock %>% arrange(desc(X.)) %>% head(10) %>% mutate (ScrapTime = format(Sys.time(), "%d-%b-%Y %H:%M:%S"), TweetStatus = 0)%>% rename (Kode=Code, Nama=Name, Sebelumnya = Prev., Penutupan = Close, Selisih = Change, SelisihPersen = X.) %>% select (-No.)
                

## Insert to MongoDb

connection_string = 'mongodb+srv://drismana:RaoY140288@clustermds.ctyf0.mongodb.net/sample_training'
top10gain_collection = mongo(collection="top10gain",
                         db="idxtopgain10bot",
                         url=connection_string)
top10gain_collection$insert(data_stock_top10gain)

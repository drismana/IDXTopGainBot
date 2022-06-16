library(rtweet)
library(ggplot2)
library(gridExtra)
library(dplyr)
library(rvest)
library(rtweet)
library(mongolite)

# Connect Mongo
connection_string = Sys.getenv("MONGO_CONNECT_URI")
top10gain_collection = mongo(collection = Sys.getenv("MONGO_COLLECTION"),
                         db= Sys.getenv("MONGO_DB"),
                         url=connection_string)


## Select from MongoDB TweetStatus = 0

tweet_upload <- top10gain_collection$find('{"TweetStatus":0}')
tweet_upload_post <- tweet_upload %>% select(-ScrapTime,-TweetStatus)
tweet_upload_time <- tweet_upload %>% select(ScrapTime) %>% head(1)


## post

token <- create_token(
  app = Sys.getenv("TWITTER_APPS_NAME"),
  consumer_key = Sys.getenv("TWITTER_API_KEY"),
  consumer_secret = Sys.getenv("TWITTER_API_SECRET"),
  access_token = Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret = Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET"))
  
  
## crate temporary file name
tmp <- tempfile(fileext = ".png")

## save as png
##png(tmp, 6, 6, "in", res = 127.5)
png(tmp, height = 30*nrow(tweet_upload_post), width = 120*ncol(tweet_upload_post))
p<-tableGrob(tweet_upload_post)
grid.arrange(p)
dev.off()

## post tweet with media attachment
post_tweet(paste0("Top 10 Gain Saham pada ",tweet_upload_time), media = tmp,token = token)  


## Ubah TweetStatus = 1

top10gain_collection$update('{"TweetStatus":0}','{"$set" :{"TweetStatus":1}}',multiple = TRUE)

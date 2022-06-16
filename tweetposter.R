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
  consumer_secret = Sys.getenv("TWITTER_API_KEY_SECRET"),
  access_token = Sys.getenv("TWITTER_ACCESS_TOKEN"),
  access_secret = Sys.getenv("TWITTER_ACCESS_TOKEN_SECRET"))
  
  
text_tweet <- paste0("Top 10 Gain Saham IDX",
                     "\n",
                     tweet_upload_time, " WIB :",
                     "\n",
                     "\n",
                     "No,Kode,Persentase Selisih",
                     "\n",
                     "#1, ", tweet_upload_post[1,1],",", tweet_upload_post[1,6],
                     "\n",
                     "#2, ", tweet_upload_post[2,1],",", tweet_upload_post[2,6],
                     "\n",
                     "#3, ", tweet_upload_post[3,1],",", tweet_upload_post[3,6],
                     "\n",
                     "#4, ", tweet_upload_post[4,1],",", tweet_upload_post[4,6],
                     "\n",
                     "#5, ", tweet_upload_post[5,1],",", tweet_upload_post[5,6],
                     "\n",
                     "#6, ", tweet_upload_post[6,1],",", tweet_upload_post[6,6],
                     "\n",
                     "#7, ", tweet_upload_post[7,1],",", tweet_upload_post[7,6],
                     "\n",
                     "#8, ", tweet_upload_post[8,1],",", tweet_upload_post[8,6],
                     "\n",
                     "#9, ", tweet_upload_post[9,1],",", tweet_upload_post[9,6],
                     "\n",
                     "#10, ", tweet_upload_post[10,1],",", tweet_upload_post[10,6],
                     "\n",
                     "\n",
                     "\n",
                     "#IDX")

## post tweet with media attachment
post_tweet(status = text_tweet, token = token)  


## Ubah TweetStatus = 1

top10gain_collection$update('{"TweetStatus":0}','{"$set" :{"TweetStatus":1}}',multiple = TRUE)

library(twitteR)
library(devtools)
library(streamR)
getwd()
setwd("/Users/Magic/Documents/UW/Methods/Project/")
twit_cred = read.csv('twitter_cred.csv', stringsAsFactors=FALSE)

TWITTER_CONSUMER_KEY = twit_cred$TWITTER_CONSUMER_KEY
TWITTER_CONSUMER_SECRET = twit_cred$TWITTER_CONSUMER_SECRET
TWITTER_ACCESS_TOKEN = twit_cred$TWITTER_ACCESS_TOKEN
TWITTER_ACCESS_SECRET = twit_cred$TWITTER_ACCESS_SECRET

setup_twitter_oauth(TWITTER_CONSUMER_KEY, TWITTER_CONSUMER_SECRET,
                    TWITTER_ACCESS_TOKEN, TWITTER_ACCESS_SECRET)

requestURL <- "https://api.twitter.com/oauth/request_token"
accessURL <- "https://api.twitter.com/oauth/access_token"
authURL <- "https://api.twitter.com/oauth/authorize"

require(ROAuth)
library(RCurl)
library(RJSONIO)
library(stringr)
my_oauth <- OAuthFactory$new(consumerKey = TWITTER_CONSUMER_KEY,
                             consumerSecret = TWITTER_CONSUMER_SECRET,
                             requestURL = requestURL,
                             accessURL = accessURL,
                             authURL = authURL)

my_oauth$handshake(cainfo = system.file("CurlSSL", "cacert.pem", package = "RCurl"))


save(my_oauth, file = "my_oauth.Rdata")

library(streamR)
load("my_oauth.Rdata")

filterStream(file.name = "warriors_test.json", # Save tweets in a json file
             track = c('Warriors','Trailblazers'),
             language = "en",
#             location = c(-119, 33, -117, 35), # latitude/longitude pairs providing southwest and northeast corners of the bounding box.
             timeout = 18000, # Keep connection alive for 60 seconds
             oauth = my_oauth) # Use my_oauth file as the OAuth credentials



tweets_geo <- parseTweets("nfl_draft3.json", simplify = FALSE) #simplify will exclude geo locations
write.csv(tweets_geo, file = "nfl_draft_2017_geo.csv", row.names = FALSE)



library(tm)
library(NLP)
library(SnowballC)
library(wordcloud)
library(e1071)
library(caret)
library(RTextTools)
library(topicmodels)
library(slam)
library(RKEA)
library(broom)
library(stringdist)
library(tidytext)
library(dplyr)


#---------Load Data----------#
load("~/Documents/UW/Methods/Project/initial tweet load.RData")
tweet_sample = sample(tweets$text, 10000, replace = FALSE)
tweet_sample = data.frame(tweet_sample, stringsAsFactors = FALSE)
names(tweet_sample) = 'text'




#---------Cleaning----------#
#had to remove ascii first, otherwise error: "invalid multibyte string 6"
tweet_sample$text = iconv(tweet_sample$text, from="latin1", to="ASCII", sub="") #remove non-ascii
tweet_sample$text <- gsub("https://t.co/[a-z,A-Z,0-9]*","",tweet_sample$text) #remove URL
tweet_sample$text <- gsub("RT @[a-z,A-Z]*: ","",tweet_sample$text) # Take out retweet header
tweet_sample$text <- gsub("#[a-z,A-Z]*","",tweet_sample$text) #remove hashtags
tweet_sample$text <- gsub("@[a-z,A-Z]*","",tweet_sample$text) #remove user references
tweet_sample$text = tolower(tweet_sample$text) #lowercase
tweet_sample$text = sapply(tweet_sample$text, function(x) gsub("'", "", x)) #remove apostrophes
tweet_sample$text = sapply(tweet_sample$text, function(x) gsub("[[:punct:]]", " ", x)) #remove other punctuation
tweet_sample$text = sapply(tweet_sample$text, function(x) gsub("\\d","",x)) #remove numbers
tweet_sample$text = sapply(tweet_sample$text, function(x) gsub("[ ]+"," ",x)) #remove extra whitespace


#stopwords
stopwords()
my_stops = as.character(sapply(stopwords(), function(x) gsub("'","",x)))
tweet_sample$text = sapply(tweet_sample$text, function(x){
paste(setdiff(strsplit(x," ")[[1]],stopwords()),collapse=" ")
})

#Remove extra white space again:
tweet_sample$text = sapply(tweet_sample$text, function(x) gsub("[ ]+"," ",x))


#remove retweets altogether - this isn't working yet. Should we do this?
#indicator for RT prefix
grep("RT",tweet_sample$text)
tweet_sample$RT = ifelse(substr(tweet_sample$text,1,2)=='RT',1,0)
tweet_sample = data.frame(tweet_sample)
tweet_sample[RT==0,1]#error here
#remove for now
tweet_sample$RT = NULL
#followup: see if you can find an original tweet if you see an RT

#identify links

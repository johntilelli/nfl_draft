require(data.table)
require(ggplot2)

getwd()
setwd('/Users/Magic/Documents/UW/Methods/Project')
list.files()

#read raw twitter data
tweets = read.csv("nfl_draft_2017_r1.csv", header = TRUE, stringsAsFactors = FALSE)

#format date
tweets$created_at_formatted = as.POSIXct(tweets$created_at,
                                            format = "%a %b %e %T %z %Y")
tweets$created_at_formatted_mins = as.POSIXct(trunc.POSIXt(tweets$created_at_formatted, "mins"))


tweets = data.table(tweets)

#count of tweets by minute
freq_m = tweets[ , .N , by = created_at_formatted_mins ]

#plot frequency time series

ggplot(freq, aes(created_at_formatted, N)) + geom_line() #per second
ggplot(freq_m, aes(created_at_formatted_mins, N)) + geom_line() #per minute


tweet_time = tweets[,.(text,created_at_formatted)]

picks = read.csv("picks.csv", header = TRUE, stringsAsFactors = FALSE)

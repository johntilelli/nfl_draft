#mapping
require(ggmap)
require(ggplot2)
require(data.table)
require(spatstat)

#data
tweet_geo = read.csv("nfl_draft_2017_geo.csv",header=TRUE, stringsAsFactors = FALSE)
summary(tweet_geo$place_lat)
tweet_geo_complete=tweet_geo[complete.cases(tweet_geo[,37:38]),]
write.csv(tweet_geo_complete, "nfl_draft_2017_geo_complete.csv", row.names = FALSE)

tweet_geo_complete = read.csv(file = "https://raw.githubusercontent.com/johntilelli/nfl_draft/master/nfl_draft_2017_geo_complete.csv"
                              , header = TRUE
                              , stringsAsFactors = FALSE)

tweet_geo_complete_dt = data.table(tweet_geo_complete) #RENAMED

tweet_geo_complete_dt = tweet_geo_complete_dt[place_lon < -50 & place_lon > -150 & place_lat > 0 & place_lat < 60]
summary(tweet_geo_complete_dt$place_lon)

plot(tweet_geo_complete_dt$place_lon, tweet_geo_complete_dt$place_lat)
tweet_coords = tweet_geo_complete_dt[,.(place_lon,place_lat)]
tweet_coords = unique(tweet_coords)

setwd("/Users/Magic/Documents/UW/Methods/Project")
#write.csv(tweet_coords, "tweet_coords.csv", row.names = FALSE)
tweet_coords = read.csv("https://raw.githubusercontent.com/johntilelli/nfl_draft/master/tweet_coords.csv", header = TRUE, stringsAsFactors = FALSE)

# Complete Randomness
x_rand = runif(200)
y_rand = runif(200)
plot(x_rand, y_rand, xlim=c(0,1),ylim=c(0,1),
     main="Random X Y Points on Unit Square", pch=16)

# Over-Regular (homogeneity)

x_reg = runif(1)
y_reg = runif(1)

while (length(x_reg)<200){
  x_temp = runif(1)
  y_temp = runif(1)
  
  # Find the min distance from our random point to all the clusters
  min_dist = min(sqrt((x_reg - x_temp)**2 + (y_reg-y_temp)**2))
  expected_even_dist = ( 4 * ( 1/sqrt(200) ) + 4 * ( sqrt(2)/sqrt(200) ) ) / 8
  
  if (min_dist > (expected_even_dist*0.65)){ # Allow for wiggle room
    x_reg = c(x_reg, x_temp)
    y_reg = c(y_reg, y_temp)
  }
}

plot(c(0,1), c(0,1), type="n",main="Homogeneous X Y Points on Unit Square")
points(x_reg, y_reg, pch=16)

#clustering
x_cluster = tweet_coords$place_lon
y_cluster = tweet_coords$place_lat

rand_ppp = ppp(x_rand, y_rand)
rand_ripleyK = Kest(rand_ppp)

reg_ppp = ppp(x_reg, y_reg)
reg_ripleyK = Kest(reg_ppp)

cluster_ppp = ppp(x_cluster, y_cluster,window=owin(c(-150,-50),c(0,60)),check = TRUE)
cluster_ripleyK = Kest(cluster_ppp, nlarge=nrow(tweet_coords))

plot(c(0,15), c(0,0.5), type="n", xlab='h', ylab="Ripley's K",
     main="Ripley's K Function")
lines(cluster_ripleyK$r, cluster_ripleyK$iso, lwd=2, col="red")
lines(rand_ripleyK$r, rand_ripleyK$iso, lwd=2, lty=1)
lines(reg_ripleyK$r, reg_ripleyK$iso, lwd=2, col="blue")
lines(rand_ripleyK$r, rand_ripleyK$theo, lwd=2, lty=8, col="green")



#mapping
require(ggmap)
require(ggplot2)
require(data.table)

#data


#tweet_geo = read.csv("nfl_draft_2017_geo.csv",header=TRUE, stringsAsFactors = FALSE)
#summary(tweet_geo$place_lat)
#tweet_geo_complete=tweet_geo[complete.cases(tweet_geo[,37:38]),]
tweet_geo_complete = read.csv(file = "https://raw.githubusercontent.com/johntilelli/nfl_draft/master/nfl_draft_2017_geo_complete.csv"
                              , header = TRUE
                              , stringsAsFactors = FALSE)
#data table
tweet_geo_complete_2 = data.table(tweet_geo_complete)
 #trim down to US coords
tweet_geo_complete_2 = tweet_geo_complete_2[place_lon < -50 & place_lon > -150 & place_lat > 0 & place_lat < 60]
summary(tweet_geo_complete_2$place_lon)

#mapping
map_latlon <- get_map(location = c(lon = mean(tweet_geo_complete$place_lon), lat = mean(tweet_geo_complete$place_lat)), zoom = 2,
                      maptype = "satellite", scale = 2)
#testing keywords
#map_fl = get_map(location = "florida", zoom = 6)
#map_miami = get_map(location = "miami", zoom = 9)

# plotting the map with some points on it
ggmap(map_latlon) +
  geom_point(data = tweet_geo_complete, aes(x = tweet_geo_complete$place_lon, y = tweet_geo_complete$place_lat, fill = "red", alpha = 0.8), size = 1, shape = 21) +
  guides(fill=FALSE, alpha=FALSE, size=FALSE)
#regular plot
plot(x = tweet_geo_complete$place_lon, y = tweet_geo_complete$place_lat)
plot(x = tweet_geo_complete_2$place_lon, tweet_geo_complete_2$place_lat)

#clustering
x_cluster = tweet_geo_complete_2$place_lon
y_cluster = tweet_geo_complete_2$place_lat

cluster_ppp = ppp(x_cluster, y_cluster,window=owin(c(-150,-50),c(0,60)))
cluster_ripleyK = Kest(cluster_ppp)

rand_ppp = ppp(x_rand, y_rand)
rand_ripleyK = Kest(rand_ppp)

reg_ppp = ppp(x_reg, y_reg)
reg_ripleyK = Kest(reg_ppp)

plot(c(0,0.25), c(0,0.25), type="n", xlab='h', ylab="Ripley's K",
     main="Ripley's K Function")
lines(rand_ripleyK$r, rand_ripleyK$iso, lwd=2, lty=1)
lines(cluster_ripleyK$r, cluster_ripleyK$iso, lwd=2, col="red")
lines(reg_ripleyK$r, reg_ripleyK$iso, lwd=2, col="blue")

lines(rand_ripleyK$r, rand_ripleyK$theo, lwd=2, lty=8, col="green")

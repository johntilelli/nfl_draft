tweet_geo_complete = read.csv(file = "https://raw.githubusercontent.com/johntilelli/nfl_draft/master/nfl_draft_2017_geo_complete.csv"
                              , header = TRUE
                              , stringsAsFactors = FALSE)

require(data.table)
tweet_geo_complete_dt = data.table(tweet_geo_complete)
d = tweet_geo_complete_dt[,.(place_lat,place_lon)]

d$x = d$place_lon
d$y = d$place_lat
d$place_lon = NULL
d$place_lat = NULL
d = d[x < -50 & x > -150 & y > 0 & y < 60]

plot(d)

require(dplyr)
kclusts = data.frame(k=1:32) %>% group_by(k) %>% do(kclust=kmeans(d, .$k))
require(broom)
clusters = kclusts %>% group_by(k) %>% do(tidy(.$kclust[[1]]))
class(clusters)


require(base)
names(clusters)[2:3] = c('x','y')
assignments = kclusts %>% group_by(k) %>% do(augment(.$kclust[[1]], d))
clusterings = kclusts %>% group_by(k) %>% do(glance(.$kclust[[1]]))

require(ggplot2)
ggplot(assignments, aes(x,y)) + geom_point(aes(color = .cluster))

#(NbClust)
#kmeans = NbClust(d, min.nc=2, max.nc=10, method="kmeans")

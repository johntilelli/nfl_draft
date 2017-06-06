n = 1000
g = 6
set.seed(g)
d <- data.frame(x = unlist(lapply(1:g, function(i) rnorm(n/g, runif(1)*i^2))),
                y = unlist(lapply(1:g, function(i) rnorm(n/g, runif(1)*i^2))))
plot(d, type = "p", col="blue", xlim=c(-5,30), ylim=c(-5,20),
     main="Initial Cluster Data", xlab="X", ylab="Y")

require(dplyr)
kclusts = data.frame(k=1:9) %>% group_by(k) %>% do(kclust=kmeans(d, .$k))
require(broom)
clusters = kclusts %>% group_by(k) %>% do(tidy(.$kclust[[1]]))
class(clusters)


require(base)
names(clusters)[2:3] = c('x','y')
assignments = kclusts %>% group_by(k) %>% do(augment(.$kclust[[1]], d))
clusterings = kclusts %>% group_by(k) %>% do(glance(.$kclust[[1]]))

require(ggplot2)
plot = ggplot(assignments, aes(x,y)) + geom_point(aes(color = .cluster)) + facet_wrap(~k) + geom_point(data = clusters, size=10, shape = "x")
plot
require(NbClust)
kmeans = NbClust(d, min.nc=2, max.nc=10, method="kmeans")
set.seed(10)
library(ggplot2)

par(mar=c(7,0,3,0))
x<- rnorm(12, mean=rep(1:3,each = 4),sd = 0.2)
y <- rnorm(12,mean=rep(c(1,2,1), each = 4), sd=0.2)

plot(x,y,col="blue", pch = 19, cex = 2)
text( x+0.05, y+ 0.05, labels=as.character(1:12))


df <- data.frame(x=x,y=y)

distxy<- dist(df)
#       1          2          3          4          5          6          7          8          9         10         11
#2  0.18358639                                                       
#3  0.13331602 0.10809706                                            
#4  0.14345524 0.16261274 0.05484252                                 
#5  1.38072866 1.52484409 1.51358885 1.51814972                      
#6  1.29047794 1.42657505 1.42223709 1.43048243 0.13382334           
#7  1.23764170 1.35028711 1.36381200 1.38095874 0.36699923 0.23963262
#8  1.33183329 1.46111961 1.46234034 1.47327250 0.18153147 0.08307798 0.19181938
#9  1.92293469 1.95001451 2.01358964 2.05270898 1.32694874 1.23589504 1.02837167 1.2553981
#10 1.61471243 1.58711288 1.67283326 1.72113553 1.54028714 1.41648729 1.17690406 1.35922078 0.62282466   
#11 2.01283899 2.02877729 2.09754908 2.13883258 1.47301729 1.38014005 1.16895982 1.30264799 0.14744585 0.59908175 
#12 2.05031013 2.08829392 2.14674411 2.18356622 1.33098160 1.25444790 1.06796227 1.17298270 0.17964629 0.80189917 0.25295542

# the distance matrix is comprised of distances for each pair of cases in the datset
# it is a measure of similarity between two cases
# by default, dist() uses euclidian distance measurement

hclustering <- hclust(distxy)
plot(hclustering)


# the dendogram does not specify the number of clusters present in the plot
# in order to dtermine the number of clusters we need to cut the tree at certain points
# the selection of the point depends on us as changing the point would change the number
# of lines our horizontal line would cut and give a cluster number result

datamatrix <- as.matrix(df)
heatmap(datamatrix)
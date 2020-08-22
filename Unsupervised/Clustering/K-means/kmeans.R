
## VISUALISATION
library(ggplot2)

ggplot(data,aes(x=Petal.Length,
                y=Petal.Width,
                color= Species))+
         geom_point()

## BUILDING MODEL

iris_cluster <- kmeans(data[1:4],
                       centers = 3,
                       nstart = 20)

# we put centers = 3 ie. k=3 because we already knew that there are three species
# we usually would use domain knowledge

## Looking for accuracy

table(iris_cluster$cluster,iris$Species)
#    setosa versicolor virginica
#1      0         48        14
#2      0          2        36
#3     50          0         0


## CLUSTER VISUALISATION

library(cluster)
clusplot(iris,
         iris_cluster$cluster,
         color = TRUE,
         shade = TRUE,
         labels = 0,
         lines = 0)
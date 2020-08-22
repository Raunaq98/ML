dir<- getwd()
path1<- paste0(dir,"/Unsupervised/Clustering/K-means/winequality-white.csv")
path2<- paste0(dir,"/Unsupervised/Clustering/K-means/winequality-red.csv")

white<- read.csv(path1,
                 header = TRUE,
                 stringsAsFactors = TRUE,sep=";")
red<- read.csv(path2,
               header = TRUE,
               stringsAsFactors = TRUE,sep=";")


### ADDING LABELS
white$label<- sapply(white$pH, 
                     function(x){ " white " })
red$label<- sapply(red$pH, 
                   function(x){ " red " })
# we couldve used any row to do this

### MERGING DATA
wine<- rbind(white,red)

### EDA
library(ggplot2)

# histogram of residual sugar with fill = wine type
ggplot(wine,aes(x=residual.sugar)) +
         geom_histogram(aes(fill=label),color="black",bins=50,alpha=0.5)+
         theme_bw()

# histogram of citric acid with fill = wine type
ggplot(wine,aes(x=citric.acid)) +
         geom_histogram(aes(fill=label),color="black",bins=50)+
         theme_bw()

# scatterplot of residual sugar v/s citric acid
ggplot(wine,aes(x = citric.acid, y = residual.sugar))+
         geom_point(aes(color=label),alpha=0.4) +
         theme_bw()


### PREPARING DATA FOR KMEANS

clust_data<- wine[1:12]
label_wine<- data.frame(label=wine[,13])


### BUILDING MODEL

wine_cluster<- kmeans(clust_data,
                      centers = 2)

### MODEL EVALUATION

table(wine$label,wine_cluster$cluster)
#             1    2
#    red    1514   85
#    white  1294 3604


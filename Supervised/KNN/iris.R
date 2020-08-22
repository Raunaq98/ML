iris_data<- iris

library(dplyr)
library(ggplot2)
library(class)

# 70:30 split
split = sample(2,nrow(iris_data), replace = TRUE, prob=c(0.7,0.3))
iris_train<- iris_data[split==1,]
iris_test<- iris_data[split==2,]

# training labels
train_labels <- iris_train[,"Species"]

# training data
iris_train <- iris_train %>% select(-Species)

# testing labels
test_labels <- iris_test[,"Species"]

# testing data
iris_test <- iris_test %>% select(-Species)

## scaling
iris_train<- scale(iris_train)
iris_test<- scale(iris_test)

# KNN model
predicted_species <- knn(train = iris_train, test = iris_test, cl = train_labels,k=1)
mean(predicted_species != test_labels)
# [1] 0.0227

predicted_Species<- NULL
error<- NULL

for(i in 1:20){
         predicted_Species <- knn(train = iris_train,test = iris_test, cl = train_labels,k=i)
         error[i]<- mean( predicted_Species != test_labels)
}
error 

k.values <- 1:20
error_df <- data.frame(error,k.values)
ggplot(error_df,aes(x=k.values, y=error)) + geom_point() +geom_line(lty="dotted", colour="red")
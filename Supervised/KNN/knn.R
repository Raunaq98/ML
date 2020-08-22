## knn ( training_data , testing_data, training_labels )

## knn( train = _____ , test = _____, cl = _____)

library(ISLR)
knn_data <- Caravan
## last column is "purchase" which indicates whether the costumer bought the insurance or not

library(dplyr)
purchase<- knn_data %>% select(Purchase)

any(is.na(knn_data))
# [1] FALSE
# checking for invalid data points

# we now need to take care of the scaling problem

var(knn_data[,1])
# [1] 165.0378

var(knn_data[,2])
# [1] 0.1647078

## thus V1 will make the model biased towards it.Similarly, there are 80+ such different scales
## we will have to scale all the columns except "Purchase"

caravan <- knn_data %>% select(-Purchase)
caravan_standardised <- scale(caravan)

var(caravan_standardised[,1])
# [1] 1
var(caravan_standardised[,2])
# [1] 1

# train test splitting
test_index <- 1:1000
test.data <- caravan_standardised[test_index,]
test.purchase <- purchase[test_index,]

train.data<- caravan_standardised[-test_index,]
train.purchase<- purchase[-test_index,]


## applying knn model

library(class)

predicted_purchase <- knn(train = train.data,test = test.data, cl = train.purchase,k=1)

missclass.error <- mean( test.purchase != predicted_purchase)
# [1] 0.117
# 11.7 % error in classification
##### this error depends on the value of K

## we can either manually change k or apply a for loop

predicted_purchase<- NULL
error<- NULL

for(i in 1:20){
         predicted_purchase <- knn(train = train.data,test = test.data, cl = train.purchase,k=i)
         error[i]<- mean( test.purchase != predicted_purchase)
}
error

## visualising K

library(ggplot2)
k.values <- 1:20
error_df <- data.frame(error,k.values)
ggplot(error_df,aes(x=k.values, y=error)) + geom_point() +geom_line(lty="dotted", colour="red")



### ANOTHER WAY PF SPLITTING DATA INTO TEST AND TRAIN

# training : 80% and test : 20%

ind <- sample(2, nrow(caravan_standardised), replace = TRUE, prob=c(0.8,0.2))

train_data <- caravan_standardised[ind==1,]
test_data <- caravan_standardised[ind==2,]


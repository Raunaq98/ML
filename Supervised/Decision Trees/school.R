library(ISLR)
school<- College

## we will be exploring the use of tree methods 
## to classify schools as Private or Public based off their features.

### EDA
library(ggplot2)

# scatterplot of grad rate vs room-board coloured by private column
ggplot(school,aes(x=Room.Board,y=Grad.Rate)) + 
         geom_point(aes(color=Private))
## the more you increase room and board cost, greater is the grad rate as well as 
## the chances of being a private college

# histogram of FT UG students coloured by private column
ggplot(school,aes(x=F.Undergrad)) + 
         geom_histogram(aes(fill=Private) ,color='black',bins=50) +
         labs(title = "histogram of FT UG students with fill = Private")
## smaller school tend to larger school

## histogram of grad rate with coloured by private
ggplot(school,aes(x=Grad.Rate)) + 
         geom_histogram(aes(fill=Private), color="black",bins=50) +
         theme_bw()
## most schools have grad rate between 50  and 100
## there is outlier with grad rate>100
library(dplyr)
school %>% filter(Grad.Rate>100)
school["Cazenovia College","Grad.Rate"] <- 100


#### TRAIN TEST SPLIT
library(caTools)
sample<- sample.split(school$Private,SplitRatio = 0.7)
train_school<- subset(school,sample==TRUE)
test_school<- subset(school,sample==FALSE)



########## using a decision tree

library(rpart)
tree<- rpart(Private ~.,method = "class",data = train_school)
summary(tree)

library(rpart.plot)
prp(tree)

tree_predictions<- predict(tree,test_school)


# predictions are in the form of a matrix of predictions
tree_predictions<- as.data.frame(tree_predictions)
fixer<- function(x){
         if(x>=0.5){
                  return("yes")
         }else{
                  return("no")
         }
}

tree_predictions$Private<- sapply(tree_predictions$Yes,fixer)

predicted_private<- as.data.frame(tree_predictions$Private)
actual_private<- as.data.frame(test_school$Private)
comparison_private<- data.frame(actual=actual_private,predicted=predicted_private)

## building confusion matrix
table(tree_predictions$Private,test_school$Private)

#       No Yes
# no   49  11
# yes  15 158

accuracy<- (49+158)/(49+11+15+158)
# [1] 0.888412


####### uisnf random forest

library(randomForest)

rf_model<- randomForest(Private~., data = train_school, importance = TRUE)
## importance returns GINI values

rf_model$confusion ## confusion matrix from train data
#     No Yes class.error
#No  130  18  0.12162162
#Yes  12 384  0.03030303

rf_model$importance

rf_prediction<- predict(rf_model,test_school)

table(rf_prediction,test_school$Private)  ## confusion matrix for test data
#rf_prediction  No Yes
#          No   53   6
#          Yes  11 163

accuracy_rf <- (53+163)/(53+6+11+163)
#[1] 0.9270386
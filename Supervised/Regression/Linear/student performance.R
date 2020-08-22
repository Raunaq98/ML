dir<- getwd()
path <- paste0(dir,"/Supervised/Regression/Linear/student-mat.csv")

student_data<- read.table(path,sep=";",header=TRUE,as.is = TRUE)
## this is the data for students enrolled in a math course

## the aim is to predict the final grades G3 based on other attributes

# checking for NA values
any(is.na(student_data))
# [1] FALSE

## EDA
library(ggplot2)
library(dplyr)


# checking correlation between the numeric columns
num.cols <- sapply(student_data,is.numeric)
cor.data<- cor(student_data[,num.cols])

library(corrgram)
library(corrplot)

corrplot(cor.data,method="color")  # requires numeric column data

# this shows that there is a high correlation between G1,G2 & G3 within themselves and
# inversely related to the failures column

corrgram(student_data)# does not require numeric filtered data

corrgram(student_data,order=TRUE, lower.panel=panel.shade,
         upper.panel=panel.pie, text.panel=panel.txt)

## splitting data
library(caTools)
set.seed(101)

sample<- sample.split(student_data$G3,SplitRatio = 0.7) # can pass any column, usually pass the one which you are preidcint to increase readability
train<- subset(student_data,sample==TRUE)
test<- subset(student_data,sample==FALSE)


## building a model
model_g3 <- lm(formula = G3 ~ . , data = train)   # "." means use all features to predict g3
summary(model_g3)
# p value should be as small as possible
# R^2 value should be as high as possible for a good model fit with r^2 = 1 being the best case

## visualising the residuals
res<- as.data.frame(residuals(model_g3))
ggplot(res,aes(x=residuals(model_g3))) + geom_histogram()
plot(model_g3)
# we see that the model is making negative predictions which is not possible as lowest score is 0.

## predicting for test data
predicted_g3 <- predict( model_g3, test)

results<- cbind(predicted_g3, test$G3)
colnames(results) <- c("predicted","actual")
results<- as.data.frame(results)

# taking care of negative values

to_zero<- function(x){
         if(x<0){
                  return(0)
         }else{
                  return(x)
         }
}

results$predicted<- sapply(results$predicted,to_zero)


# calculating accuracy metrics
mse <- mean( (results$actual - results$predicted)^2)
# [1] 3.400128

rmse<- sqrt(mse)
# [1] 1.843944

SSE <- sum( (results$predicted - results$actual)^2)
SST<- sum( (mean(student_data$G3) - results$actual)^2 )

r_squared<- 1-SSE/SST
# [1] 0.8334275
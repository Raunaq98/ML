dir<- getwd()
path1<- paste0(dir,"/Supervised/SVM/loan_data.csv")

loan<- read.csv(path1,header = TRUE, stringsAsFactors = TRUE)

# To classify and predict whether or not the borrower paid back their loan in full.

#### converts categorical columns to factor types
loan$credit.policy<- factor(loan$credit.policy)
loan$inq.last.6mths<- factor(loan$inq.last.6mths)
loan$delinq.2yrs<- factor(loan$delinq.2yrs)
loan$pub.rec<- factor(loan$pub.rec)
loan$not.fully.paid<- factor(loan$not.fully.paid)

#### EDA
library(ggplot2)
library(dplyr)

# histogram of fico scores coloured by not.fully.paid
ggplot(loan,aes(x=fico)) +
         geom_histogram(aes(fill=not.fully.paid),color="black")+
         theme_bw() +
         labs(title = "Fico scores histogram with not paid colour")
# as fico scores get higher, people tend to pay their loans more

# barplot of purpose
ggplot(loan,aes(x=purpose)) +
         geom_bar(aes(fill=not.fully.paid), color="black")+
         theme_bw()+
         labs(title = "Purpose barplot with fill=bot.fully.paid")

# fico vs interest rate
ggplot(loan,aes(x=fico,y=int.rate)) +
         geom_point(position = "jitter",aes(color=not.fully.paid),alpha=0.4)+
         theme_bw() +
         labs(title = "Interest rate vs Fico Scores")
# if fico score goes down then interest rate increases


#### TRAIN TEST SPLIT
library(caTools)
sample<- sample.split(loan$not.fully.paid,SplitRatio = 0.7)
train_loan<- subset(loan,sample==TRUE)
test_laon<-subset(loan,sample==FALSE)


#### BUILDING MODEL
library(e1071)

loan_svm<- svm(not.fully.paid ~., data = train_loan)
summary(loan_svm)
## cost = 1      &     gamma = 0.25


#### PREDICTIONS
predicted_values <- predict(loan_svm, test_laon[1:13])     # removing label from test
table(predicted_values,test_laon$not.fully.paid)
#predicted_values    0    1
#                0 2413  460
#                1    0    0

# this is very wrong and happens because of wrong C and Gamma


#### TUNING THE MODEL
tuned_loan_svm <- tune(svm, 
                       train.x = not.fully.paid~., 
                       data=train_loan ,
                       kernel = "radial",
                       ranges = list(cost=c(50,100,200), gamma=c(0.1,0.75)))
summary(tuned_loan_svm)
#best parameters:
#         cost gamma
#          50  0.75

# best performance: 0.1907534   ie. error of 19%

tuned_final<- svm(not.fully.paid~. ,
                  data = train_loan,
                  cost=50,
                  gamma=0.75)
predicted_values<- predict(tuned_final,
                           test_laon[1:13])
tb<-table(predicted_values,test_laon$not.fully.paid)
#predicted_values    0    1
#               0 2265  439
#               1  148   21

accuracy<- sum(diag(tb))/sum(tb)
# [1] 0.795684



## for better results, use a large range of c and gamma for hyper parameter tuning

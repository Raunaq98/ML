library("e1071")


data<- iris

svm_model<- svm(Species~.,data = data)
summary(svm_model)

## tuning the SVM with cost and gamma

tune_results <- tune(svm, train.x = iris[1:4], train.y = iris[,5] , kernel = "radial" ,
                     ranges = list(cost=c(0.1,1,10),gamma=c(0.5,1,2)))
## assuming iris[1:4] is training set

summary(tune_results)
# Parameter tuning of ‘svm’:

#sampling method: 10-fold cross validation     ******

#best parameters:
#   cost gamma                      ******
#    1   0.5

#best performance: 0.04                      ******

#Detailed performance results:
#   cost gamma      error dispersion
#1  0.1   0.5 0.06000000 0.05837300
#2  1.0   0.5 0.04000000 0.05621827
#3 10.0   0.5 0.04666667 0.05488484
#4  0.1   1.0 0.06666667 0.07027284
#5  1.0   1.0 0.05333333 0.05258738
#6 10.0   1.0 0.05333333 0.05258738
#7  0.1   2.0 0.07333333 0.03784308
#8  1.0   2.0 0.04666667 0.04499657
#9 10.0   2.0 0.05333333 0.05258738

## we can tune again by choosing values near c=1 and gamma=0.5 and so on

## assuming we want to use c=1 and gamma=0.5

tuned_svm<- svm(Species~.,data = data, kernel = "radial", cost=1, gamma=0.5)
summary(tuned_svm)

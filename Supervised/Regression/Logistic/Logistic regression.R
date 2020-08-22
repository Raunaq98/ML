train_titanic <- read.csv(paste0(dir,"/Supervised/Regression/Logistic/titanic_train.csv"), 
                          header = TRUE, stringsAsFactors = TRUE)

test_titanic <- read.csv(paste0(dir,"/Supervised/Regression/Logistic/titanic_test.csv"), 
                         header = TRUE, stringsAsFactors =  TRUE)


## missing data
# we can explore missing data using the Amelia package
library(Amelia)
missmap(train_titanic, main = "Missing Map", col = c("yellow","black"))

# alot of data points for age are missing

### EDA
library(ggplot2)
library(dplyr)

#exploring data division
ggplot(train_titanic,aes(x= Survived)) + geom_bar(aes(fill=factor(Survived))) + 
         labs(title = "Survived Barplot")
#around 66% of people died

ggplot(train_titanic,aes(x= Pclass)) + geom_bar(aes(fill=factor(Pclass))) + 
         labs(title = "Pclass Barplot")
# class 3 was the majority class

ggplot(train_titanic,aes(x= Sex)) + geom_bar(aes(fill=factor(Sex))) + 
         labs(title = "Sex Barplot")
# there were more males on board

ggplot(train_titanic,aes(SibSp)) + geom_bar(aes(fill=factor(SibSp))) + 
         labs(title = "Siblings/Spouses on-board")
# most people didnt have siblings/spouses

ggplot(train_titanic,aes(Parch)) + geom_bar(aes(fill=factor(Parch))) + 
         labs(title = "Parents/Children on-board")
# # most people did not have parents/ children

ggplot(train_titanic,aes(x=Age)) +geom_histogram(bins = 20, alpha=0.2,fill="red") + 
         labs(title = "Age Histogram")
# middle age > younger > old

ggplot(train_titanic,aes(x=Fare)) +geom_histogram(bins = 20, alpha=0.2,fill="red") + 
         labs(title = "Fare Histogram")
# most people paid a low fare === most people were on class 3 of ticket


### imputing missing ages
# instead of imputing using mean of age, we can impute using mean of age in each class

ggplot(train_titanic,aes(x=Pclass,y=Age)) + geom_boxplot(aes(color=factor(Pclass))) +
         scale_y_continuous(breaks = seq(0,80,by=2)) + theme_bw()
# age( 1st ) > age( 2nd ) > age( 3rd)

impute_age <- function(age,class){
         out <- age
         for (i in 1:length(age)){
                  
                  if (is.na(age[i])){
                           
                           if (class[i] == 1){
                                    out[i] <- 37
                                    
                           }else if (class[i] == 2){
                                    out[i] <- 29
                                    
                           }else{
                                    out[i] <- 24
                           }
                  }else{
                           out[i]<-age[i]
                  }
         }
         return(out)
}

fixed_ages<- impute_age(train_titanic$Age,train_titanic$Pclass)
train_titanic$Age<- fixed_ages

## cleaning data for model

clean_data <- train_titanic %>% select(-PassengerId,-Name,-Ticket,-Cabin)
# try to make factors if numeric values are have small ranges

clean_data$Survived<- factor(clean_data$Survived)
clean_data$Pclass<- factor(clean_data$Pclass)
clean_data$Parch<- factor(clean_data$Parch)
clean_data$SibSp<- factor(clean_data$SibSp)

## building model

log_model <- glm(formula= Survived ~. , family = binomial(link = "logit"), data = clean_data)
summary(log_model)
## class, sex, age, sibsp==3/4  have the most importance

## adjusting levels differences

test_clean_final<- test_titanic
test_clean_final[343,7]<- 6
test_clean_final[366,7]<- 6


## cleaning test data

passenger_id<- test_clean_final %>% select(PassengerId)
test_clean<- test_clean_final %>% select(-PassengerId,-Name,-Ticket,-Cabin)

test_fixed_ages <- impute_age(test_clean$Age,test_clean$Pclass)
test_clean$Age<- test_fixed_ages

test_clean$Pclass<- factor(test_clean$Pclass)
test_clean$SibSp<- factor(test_clean$SibSp)
test_clean$Parch<- factor(test_clean$Parch)

## MAKING PREDICTIONS

fitted_probabilities <- predict(log_model,test_clean,type="response")
fitted.results <- ifelse(fitted_probabilities > 0.5,1,0)

survivors<- data.frame(PassengerId= passenger_id, Survived= fitted.results)

### if we had a train-test split with survivor column in both:

misClasificError <- mean(fitted.results != test_clean$Survived)
print(paste('Accuracy',1-misClasificError))
table(final.test$Survived, fitted.probabilities > 0.5)
path<- paste0(dir,"/Supervised/Regression/Logistic/adult_sal.csv")
salary<- read.csv(path, stringsAsFactors = TRUE, header = TRUE)

# based on other attributes, we have to predict if someone makes more than 50K or not

library(dplyr)
library(ggplot2)

salary<- salary %>% select(-X)

### DATA CLEANING

# combine employer type factors

clean_job<- function(job){
         job<- as.character(job)
         if(job=="Never-worked" | job == "Without-pay"){
                  return("unemployed")
         }else if(job=="Self-emp-inc" | job == "Self-emp-not-inc"){
                  return("self_employed")
         }else if(job=="Local-gov" | job == "State-gov"){
                  return("S-L gov")
         }else{
                  return(job)
         }
}
salary$type_employer<- sapply(salary$type_employer,clean_job)

clean_marriage<- function(mar){
         mar<- as.character(mar)
         if(mar=="Divorced" | mar=="Separated" | mar=="Widowed"){
                  return("not_married")
         }else if( mar=="Married-AF-spouse" | mar=="Married-civ-spouse" | mar=="Married-spouse-absent"){
                  return("married")
         }else{
                  return("never_married")
         }
}
salary$marital<- sapply(salary$marital,clean_marriage)


asia <- c('China','Hong','India','Iran','Cambodia','Japan', 'Laos' ,
          'Philippines' ,'Vietnam' ,'Taiwan', 'Thailand')

north_america <- c('Canada','United-States','Puerto-Rico' )

europe <- c('England' ,'France', 'Germany' ,'Greece','Holand-Netherlands','Hungary',
            'Ireland','Italy','Poland','Portugal','Scotland','Yugoslavia')

latin_south_america <- c('Columbia','Cuba','Dominican-Republic','Ecuador',
                         'El-Salvador','Guatemala','Haiti','Honduras',
                         'Mexico','Nicaragua','Outlying-US(Guam-USVI-etc)','Peru',
                         'Jamaica','Trinadad&Tobago')
other <- c('South')

clean_country<- function(country){
         country<-as.character(country)
         if(country %in% asia){
                  return("asia")
         }else if(country %in% north_america){
                  return("north_america")
         }else if(country %in% europe){
                  return("europe")
         }else if(country %in% latin_south_america){
                  return("latin/south_america")
         }else{
                  return("other")
         }
}
salary$country<-sapply(salary$country,clean_country)

salary$type_employer<-factor(salary$type_employer)
salary$marital<- factor(salary$marital)
salary$country<-factor(salary$country)

## renaming
salary<- salary %>% rename(region = country)

### MISSING DATA

salary[salary=="?"] <- NA
# since we have changed ? to NA, old factors will still have ? with zero points
## we need to remove them, easiest way to do that is:
salary$type_employer<-factor(salary$type_employer)
salary$occupation<-factor(salary$occupation)


library(Amelia)
missmap(salary,col=c('yellow','black'))

# NAs are present in occupation and type_employer are not numeric
# we cannot empute using mean etc
# we can drop the data as it is only 1%

salary<- na.omit(salary)

### VISUALISATION

# ages coloured by income
ggplot(salary,aes(x=age)) +
         geom_histogram(binwidth=1,aes(fill=income),color='black') + 
         theme_bw()

# hours worked per week histogram
ggplot(salary,aes(x=hr_per_week)) +
         geom_histogram(binwidth=1,color="black")+
         theme_bw() + scale_x_continuous(breaks = seq(1,99,by=4))

# barplot of region with fill colour as income 
ggplot(salary,aes(x=region)) +
         geom_bar(aes(fill=income),position = "dodge")+
         theme_bw()

### SPLITTING DATA
library(caTools)
set.seed(101)
sample <- sample.split(salary$income, SplitRatio = 0.7)
train_salary<- subset(salary,sample==TRUE)
test_salary<- subset(salary,sample==FALSE)


### BUILDING MODEL

salary_model<- glm(income ~.,family = binomial(logit), data = salary)
summary(salary_model)
## we can reduce the levels for education and occupation

step_salary_model<- step(salary_model)
### step() removes features not important to the regression model

summary(step_salary_model)
# it decided to keep all features we use, we couldve changed occupation and education columns

### PREDICTIONS

test_salary$predicted_income <- predict(salary_model, newdata = test_salary, type = 'response')

### CREATING CONFUION MATRIX

table(test_salary$income, test_salary$predicted_income > 0.5)
#         FALSE TRUE
#  <=50K  6389  531
#  >50K    890 1405

accuracy <- (6389+1405)/(6389+531+890+1405)
accuracy
# [1] 0.8457949

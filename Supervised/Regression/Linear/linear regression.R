### linear regression in R has the following form:
#  lm( formula =  y ~ x + z + ... , data = ... )

# model <- lm ( .......)
# predicted_variable <- predict( model , newdata = ...)


dir<- getwd()
path<- paste0(dir,"/Supervised/Regression/Linear Regression/Galton.txt")

library(data.table)
galton_data <- fread(path)


library(ggplot2)
library(dplyr)

galton_data %>% ggplot(aes(x=Father, y = Height)) +geom_point() + 
         labs(title = "Simple scatterplot for father-child data")


## adding linear regression line
galton_data %>% ggplot(aes(x=Father, y = Height)) +
         geom_point() + 
         labs(title = "Father-child scatterplot with linear regression") +
         geom_smooth(method="lm", se= FALSE)   # se=FALSE removes smooth error region

## adding a diagnol ( where father and child have equal heights)
galton_data %>% ggplot(aes(x=Father, y = Height)) +
         geom_point() + 
         labs(title = "Father-child scatterplot with linear regression and diagonal") +
         geom_smooth(method="lm", se= FALSE) +
         geom_abline(slope=1,intercept = 0)

## comparison of lm with diagnol shows that eventhough model predicted heights to increase
## it was still not upto the mean heights
## this leads to regression over mean

### fitting the model

# lm( formula = dependent ~ independent , data = )

model_LR <- lm(formula = Height ~ Father, data= galton_data)
model_LR
#Coefficients:
# (Intercept)       Father  
#    39.1104       0.3994

#  Height = 39.1104 + (0.3994)*Father

fitted.values(model_LR)
# this returns the y-hat values or the predicted values to compute the sum(e^2)

residuals(model_LR)
# this returns e = y - (y-hat) value for each observation

library(broom)
augment(model_LR)
# this returns a consolidated table for the model containing all its info

#### MAKING PREDICTIONS

new_data<- data.frame(Father=c(80,79.6,70))
predict(model_LR,new_data)
#       1        2        3 
#  71.06089 70.90114 67.06708 

# visualing the new predictions
temp<- data.frame(predict(model_LR,new_data),Father=c(80,79.6,70))
names(temp) <- c("Height","Father")

ggplot(galton_data,aes(x=Father,y=Height)) + geom_point() +
         geom_smooth(method="lm", se=FALSE) +
         geom_point(data = temp,aes(x=Father, y = Height,colour="red"))


### EVALUATING MODEL FIT

model_LR %>% augment() %>%
         summarise(SSE = sum(.resid^2))
#     SSE
#  1 10642.
# SSE = Sum of Squared Errors
# SSE needs to be min for model fit

summary(model_LR)

#Call:
#lm(formula = Height ~ Father, data = galton_data)

#Residuals:
#         Min       1Q   Median       3Q      Max 
#      -10.2683  -2.6689  -0.2092   2.6342  11.9329 

#Coefficients:
#          Estimate Std. Error t value Pr(>|t|)    
# (Intercept) 39.11039    3.22706  12.120   <2e-16 ***
# Father       0.39938    0.04658   8.574   <2e-16 ***
#         ---
# Signif. codes:  0 ‘***’ 0.001 ‘**’ 0.01 ‘*’ 0.05 ‘.’ 0.1 ‘ ’ 1

# Residual standard error: 3.446 on 896 degrees of freedom
# Multiple R-squared:  0.07582,	Adjusted R-squared:  0.07479 
# F-statistic: 73.51 on 1 and 896 DF,  p-value: < 2.2e-16

# Residual standard error of 3.446 means that the height of predicted child is within the 
# 3.446 cm rangeof the actual value.

## comparing different models using SSE or RMSE is tough as they have units
## one way of doing this would be by using a universal parameter

## USING A NULL MODEL

model_null <- lm( Height ~ 1,galton_data)
temp2 <- model_null %>% augment() %>%
         summarise(SST = sum(.resid^2))
#      SST
# [1] 11515

# SST = Sum of Squares Total

# R^2 = 1 - ( SSE / SST )

# this is a direct measure of quality of a model fit 


#### UNUSUAL POINTS

model_LR %>% augment() %>% arrange( -.hat, .cooksd)
# a combination of high .hat and low .cooksd values point to outliers
# these can drive the slope of a lm drastically
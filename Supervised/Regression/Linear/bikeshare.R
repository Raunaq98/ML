path<- paste0(dir,"/Supervised/Regression/Linear/bikeshare.csv")

bike<- read.csv(path, header = TRUE, as.is = TRUE)

## we want to prdict "count" for a particular hour

library(ggplot2)
library(dplyr)

# checking for NA values
any(is.na(bike))
# [1] FALSE

# checking correlation
library(corrgram)
corrgram(bike,order=TRUE, lower.panel=panel.shade,
         upper.panel=panel.pie, text.panel=panel.txt)

## what this doesnt take into account is time which is saved as a char

#EDA
ggplot(bike,aes(x=temp,y=count)) +geom_point(alpha=0.2,aes(color=temp),position = "jitter")+
         geom_smooth(method=lm)
## it can be seen that as temperature increases, the value of count also increases

# converting time from char to POSIXct
bike$datetime <- as.POSIXct(bike$datetime)
ggplot(bike,aes(x=datetime,y=count)) + geom_point(alpha=0.2,aes(color=temp))
# what this graph tells us is that count has been increasing with time but is still not clear about temperature

# we can further edit it to be more explanatory
ggplot(bike,aes(x=datetime,y=count)) + geom_point(alpha=0.2,aes(color=temp))+
         scale_color_continuous(low="green",high="red") +theme_bw()
# hence, it is now clear that count increases for hotter months


## so far, we have realised that as time progresses, count increases and
## it increases even more for summer

## correlation between temp and count
cor(bike$temp,bike$count)
# [1] 0.3944536

## exploring seasons even more
ggplot(bike,aes(x=factor(season), y = count)) + geom_boxplot(aes(color=factor(season))) + theme_bw()
## shows non-linear growth and fall
## seasons 2 and 3 show biggest increase while 4 shows decrease from 3 but still an overall growth


## FEATURE ENGINEERING

bike$hour <- sapply(bike$datetime,function(x){
         format(x,"%H")
})
# we did this because we want to predict for a certain hour of the day

working_day <- bike %>% filter(workingday==1) %>% ggplot(aes(x = hour, y = count)) + 
         geom_point(aes(color=temp),position = "jitter") +theme_bw() + scale_color_continuous(low="green",high="red")+
         labs(title = "working day")
working_day

non_working_day<- bike %>% filter(workingday==0) %>% ggplot(aes(x = hour, y = count)) + 
         geom_point(aes(color=temp),position = "jitter") +theme_bw() + scale_color_continuous(low="green",high="red")+
         labs(title = "non working day")
non_working_day

library(cowplot)
plot_grid(working_day,non_working_day)
## thus there is a clear trend on working and non working datys

### building model just for temp
# as data is a time series, we cant randomly split into train test as it has seasonality


## thus, the data shows constant growth that even has seasonality and trends based on hour of the day
## hence, lineqar regression wouldnt be a good fit 
## what would be a better approach wuld be to treat this as "past" data and then predict "future" data
## this wouldnt utilise linear regression


temp_model<- lm( formula = count ~ temp, data= bike)
summary(temp_model)

bike_model<- lm( formula = count ~. , data = bike)
summary(bike_model)


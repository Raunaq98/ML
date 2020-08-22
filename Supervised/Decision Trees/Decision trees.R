library(rpart)
kyphosis_data<- kyphosis
#Kyphosis-a factor with levels absent present indicating if a kyphosis (a type of deformation) was present after the operation.


### building tree model

tree <- rpart(formula = Kyphosis ~., method="class", data=kyphosis_data)

## examining results

printcp(tree)              # display cp table

plot(tree,uniform=TRUE,main="kyphosis tree") ## just makes the branches

text(tree, use.n = TRUE,all = TRUE) ## adds text to tree

### better way to visualize
library(rpart.plot)
prp(tree)


library(randomForest)

rf<- randomForest(Kyphosis~., data = kyphosis_data)
rf

## communication with random forest

predicted_values <- rf$predicted

trees_grown<- rf$ntree
#  [1] 500

confusion_matrix <- rf$confusion
#         absent present class.error
#absent      60       4   0.0625000
#present     14       3   0.8235294

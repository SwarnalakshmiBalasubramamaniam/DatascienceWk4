fitData <- function()
{
  library(caret)
  library(ggplot2)
  library(e1071)
  library(rpart.plot)
  set.seed(42)
  traindf <- read.csv("pml-training.csv")
  testdf <- read.csv("pml-testing.csv")
  ##trim out na values
  #Building a test set
  testdf<-testdf[,!apply(testdf,2,function(x) all(is.na(x)))]
  vecnames <- colnames(testdf)
  fname<-""
  for(i in 1:length(colnames(traindf)))
      {
    for( j in 1:length(vecnames))
    {
    if(tolower(trimws(colnames(traindf[i])))==tolower(trimws(vecnames[j])))
      fname[j] <- colnames(traindf[i])
    }
  }
  #Created to remove the additional columns that are not in the test set and also na columns
   filteredtraindf <-subset(traindf,select = c(fname))
   filteredtraindf<-cbind(filteredtraindf,classe=traindf$classe)
   #Removing the first 6 columns that do no add value to the predict function
   filteredtraindf <- filteredtraindf[,6:ncol(filteredtraindf)]
   controlparam <-  trainControl(method="cv",number = 5)
  # folds<-createFolds(y=filteredtraindf$classe,k=10,list=TRUE,returnTrain = TRUE)
  # modfit <- train(classe ~.,method="glm",data=filteredtraindf)
  # # predictClasse <- predict(modfit,testdf)
  # # predictClasse
  # modfit
   #Split the training data in training set and testing set
  inTrain <- createDataPartition(filteredtraindf$classe,p=0.7,list=FALSE)
  trainingset <- filteredtraindf[inTrain,]
  testingset <- filteredtraindf[-inTrain,]
  #fit using the r part method
   modFit <- rpart(classe~.,data=trainingset,method="class")
   predictclasse <- predict(modFit,testingset,type="class")
   confusionMatrix(testingset$classe,predictclasse)
   #Calculate accuracy and out of sample error
   accuracy <-postResample(predictclasse,testingset$classe)
   outofsampleerr <- 1- confusionMatrix(testingset$classe,predictclasse)$overall[1]
   #create a random forest with the traininset
  modelRF <- train(classe~.,data=trainingset,method="rf",trcontrol=controlparam,ntree=250)
  predictRF <- predict(modelRF, testingset)
  confusionMatrix(testingset$classe, predictRF)
  #calculate accuracy and out of sample error, i have used both rpart and RF to see the best classification by calculating the accuracy
  accuracy <- postResample(predictRF, testingset$classe)
  ose <- 1 - as.numeric(confusionMatrix(testingset$classe, predictRF)$overall[1])
  predictrftest<-predict(modelRF, testdf[, -length(names(testdf))])
  #writing the out put to the file
  write_files = function(x){
    n = length(x)
    filename <- "outputdata.txt"
    write.table(x, file = filename, quote = FALSE, row.names = FALSE, col.names = FALSE)

  }
  write_files(predictrftest)
  rm(modelRF)
  rm(trainingset)
  rm(testingset)
  rm(testdf)
  rm(predictRF)
  rm(accuracy)
  rm(ose)
  rm(pml_write_files)
  
}
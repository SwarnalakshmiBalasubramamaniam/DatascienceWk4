# DatascienceWk4
Project on fit data classification
The data is initially read from the csv files. The wd is set to the path containing csv files
The data  read into traindf and testdf.Then both the traindf and testdf is cleaned
The cleaning process is done by removing all the columns with na and the columns which doesnt help in predicition
Once the data is cleaned, the training data set it subset with only the columns in the test data set
The finale data set we have after complete cleaning is filteredtraindf, this data set is then partitioned to test set and training set using the create data partition command
The split data set is then called trainingset and testingset
The trainingset is used to train the model using the rpart method
The outcome is in modfit
modfit is then used to predict the testingset
Accuracy and out of sample error is then calculated
The Accuracy using rpart method is 0.7350892 and the outofsample error is 0.2649108
We then use cross validation with 5 folds in the controlparam variable
modelRF is the variable which has the outcome when randomforest is used with cross validation
We then predict using the testingset.
The accuracy with the random forest method is 0.9979609 and out of sample error is 0.002039082
So conclusion is the random forest method has a better accuracy than rpart.
Later using the randomforest fit the testdf (original test data set with 20 use cases) is used to predict the outcome
This is written into an output file which is submitted as outputdata.txt

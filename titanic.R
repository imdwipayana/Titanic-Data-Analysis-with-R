#setting working directory
setwd("~/R/Titanic Data Analysis")

#--------------------------------------------------------------
# Menggunakan library random forest
#--------------------------------------------------------------
library(randomForest)

#--------------------------------------------------------------
# calling the csv data
#--------------------------------------------------------------
train <- read.csv(file="https://raw.githubusercontent.com/imdwipayana/DATA/main/Data%20Titanic/train.csv", stringsAsFactors = FALSE, header = TRUE)
test <- read.csv(file="https://raw.githubusercontent.com/imdwipayana/DATA/main/Data%20Titanic/test.csv",stringsAsFactors = FALSE,header = TRUE)

#---------------------------------------------------------------
# You may check the head and tail by using:
# head(train)
# tail(train)
#---------------------------------------------------------------
head(train)

#---------------------------------------------------------------
# The main purpose for the next step is imputing the missing 
# value by the median
#---------------------------------------------------------------
median(train$Age)
#---------------------------------------------------------------
# the result for median above is NA because there are missing 
# value in Age data
#---------------------------------------------------------------

median(train$Age, na.rm = TRUE)
median(test$Age, na.rm = TRUE)
#---------------------------------------------------------------
# the command above for calculating the median of the Age after 
# ignoring the missing value
#---------------------------------------------------------------

#---------------------------------------------------------------
# calling the column name for each data
#---------------------------------------------------------------
names(train)
names(test)

#---------------------------------------------------------------
# there is only one different column which is Survived column 
# in train data
#---------------------------------------------------------------

#---------------------------------------------------------------
# adding a new column is each dataset with different values.
# TRUE for train dataset and FALSE for test dataset.
#---------------------------------------------------------------

train$divide <- TRUE
test$divide <- FALSE

#---------------------------------------------------------------
# Create a new column for test dataset called Survived with 
# all values are NA
#---------------------------------------------------------------
test$Survived <- NA

#---------------------------------------------------------------
# checking the number of column for test dataset
#---------------------------------------------------------------

ncol(test)
names(test)

#--------------------------------------------------------------
# concat the two dataset
#--------------------------------------------------------------
all.data <- rbind(train,test)

#--------------------------------------------------------------
# looking for the divide column on all.data data set
#--------------------------------------------------------------
table(all.data$divide)

#--------------------------------------------------------------
# testing for empty dataset
#--------------------------------------------------------------
table(all.data$Embarked)

#--------------------------------------------------------------
# Impute the missing data of embarked
#--------------------------------------------------------------
all.data[all.data$Embarked=='','Embarked'] <- 'S'

#--------------------------------------------------------------
# looking for NA data on Age
#--------------------------------------------------------------
table(is.na(all.data$Age))

#--------------------------------------------------------------
# calculate median of full dataset
#--------------------------------------------------------------
median.age <- median(all.data$Age, na.rm=TRUE)

#--------------------------------------------------------------
# Impute Age missing data with median of the age
#--------------------------------------------------------------
all.data[is.na(all.data$Age),"Age"] <- median.age

#--------------------------------------------------------------
# Checking there is no remaining missing data on the Age
#--------------------------------------------------------------
table(is.na(all.data$Age))

#--------------------------------------------------------------
# calculate median of Fare
#--------------------------------------------------------------
median.fare <- median(all.data$Fare, na.rm=TRUE)

#--------------------------------------------------------------
# Impute Fare missing data with median of Fare
#--------------------------------------------------------------
all.data[is.na(all.data$Fare),'Fare'] <- median.fare

#--------------------------------------------------------------
# Checking Fare missing values
#--------------------------------------------------------------
table(is.na(all.data$Fare))

#--------------------------------------------------------------
# categorical casting. Example on Sex: Male 1, Female 0
#--------------------------------------------------------------
all.data$Pclass <- as.factor(all.data$Pclass)
all.data$Sex <- as.factor(all.data$Sex)
all.data$Embarked <- as.factor(all.data$Embarked)

#--------------------------------------------------------------
# divide back the full data into train and test data
#--------------------------------------------------------------
train <- all.data[all.data$divide==TRUE,]
test <- all.data[all.data$divide==FALSE,]

#--------------------------------------------------------------
# checking data type
#--------------------------------------------------------------
str(train)

train$Survived <- as.factor(train$Survived)

#--------------------------------------------------------------
# Predictive model using Random Forest
#--------------------------------------------------------------
survived.app <- "Survived  ~ Pclass + Sex + Age + SibSp + Parch + Fare + Embarked"
survived.formula <- as.formula(survived.app)



model.titanic <- randomForest(formula=survived.formula, data=train, ntree=500, mtry = 3, nodesize=0.01*nrow(test))

feature.app <- "Pclass + Sex + Age + SibSp + Parch + Fare + Embarked"

Survived <- predict(model.titanic, newdata = test)

#-------------------------------------------------------------
# Create dataframe for Kaggle submission
#-------------------------------------------------------------
PassengerId <- test$PassengerId

result <- as.data.frame(PassengerId)
result$Survived <- Survived

#--------------------------------------------------------------
# Write data to csv as Submission to Kaggle
#--------------------------------------------------------------
write.csv(result, file="Submission.csv", row.names=FALSE)


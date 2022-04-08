#setting working directory
setwd("~/Video R/Titanic")

# calling the csv data
train <- read.csv(file="https://raw.githubusercontent.com/imdwipayana/DATA/main/Data%20Titanic/train.csv", stringsAsFactors = FALSE, header = TRUE)
test <- read.csv(file="https://raw.githubusercontent.com/imdwipayana/DATA/main/Data%20Titanic/test.csv",stringsAsFactors = FALSE,header = TRUE)

#-------------------------------------------
# You may check the head and tail by using:
# head(titanic.train)
# tail(titanic.train)
#-------------------------------------------
head(titanic.train)

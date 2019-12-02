#imported the train_numeric.csv as a data_frame;
summary(train_numeric)

view(train_numeric)

#view didn't run because this file was huge
# train_categorical dataset didn't import because it was too big;
#so this data needs to be subset to include few obs and few vars withthe response variable to enable modeling

#this data is too big, so we need to subset the dataset into a smaller one to work with 
#restricting observation to 25000 and variables to 100; must include response variable

#trim columns first
colnames(train_numeric) # will give us a list of all colimns in the dataset)

#select a few vars youi want to keep and put column names in an array
myvars <- c("Response", "Id","L0_S0_F0",     "L0_S0_F2",    "L0_S0_F4",    "L0_S0_F6",     "L0_S0_F8", "L0_S0_F10",    "L0_S0_F12",    "L0_S0_F14",    "L0_S0_F16",    "L0_S0_F18",    "L0_S0_F20",   "L0_S0_F22",    "L0_S1_F24",    "L0_S1_F28",    "L0_S2_F32",    "L0_S2_F36",    "L0_S2_F40")

#create a smaller dataset with only the columns you have defined in an array
train1 <- train_numeric[,myvars]

#trim rows next

train2 <-train1[1:10000,]
# train 2 is our operating data frame with 10000 obs and 19 vars;


summary(train2)

#export the train 2 dataset to ensure that we dont lose it when the session stops
write.csv(train2, "C:/Users/snamuduri/OneDrive - Omnitracs/R datasets/bosch-production-line-performance/train2.csv")



#try and read a subset of the categorical dataset;
#this is how you can read in only 10K obs in line)
library(readr)

train_cat <- read.csv(file="C:/Users/snamuduri/OneDrive - Omnitracs/R datasets/bosch-production-line-performance/train_categorical.csv",nrows=10000)
colnames(train_cat)

#this is how you will read in only a few variables
library(data.table)
train_cat2 <- fread("C:/Users/snamuduri/OneDrive - Omnitracs/R datasets/bosch-production-line-performance/train_categorical.csv", select=c("Id","L0_S1_F25","L0_S1_F27","L0_S1_F29","L0_S1_F31","L0_S2_F33"))

train2_cat <- train_cat2[1:10000,]

#train2_cat has only 10K obs and 6 vars (inlcuidng ID). now export this to save it;
write.csv(train2_cat, "C:/Users/snamuduri/OneDrive - Omnitracs/R datasets/bosch-production-line-performance/train2_cat.csv")

#start workign with the train2.csv file
#read it in again with the wizard
#when you're reading this CSV file, yu can change null values to NAs which can then be imputed using mice

train2 <- read.csv('C:/Users/snamuduri/OneDrive - Omnitracs/R datasets/bosch-production-line-performance/train2.csv', header = T, na.strings = "NA")
#run summaries;
summary(train2)

#run SVM model

library("e1071")
#excluding variables for X variables
attach(train2)
myvars <- names(train2) %in% c("X1","Id")
train3 <- train2[!myvars]

library(mice)

mymice <- mice(train3, m=3, method = "rf")
train4 <- complete(mymice, 1)
summary(train4)

myvar <- names(train4) %in% c("L0_S0_F22","X")
train5 <- train4[!myvar]

summary(train5)

attach(train5)

x <- train5[,2:17]
y <- Response

summary(x)


svm_model <- svm(Response ~ ., data=train5)
summary(svm_model)

svm_model1 <- svm(x,y, na.action = na.fail)
summary(svm_model1)

#run prediction

pred <- predict(svm_model1,x)
system.time(pred <- predict(svm_model1,x))

length(y)
length(pred)

table(pred,y)
summary(pred)

library(ggplot2)

plot(y, pred, col = "green")

#----SN- Done till here


# the above methodology is from an example of c-classification type, which had categorical variable for Y. out data has a numberic variable, so svm is defaulting to eps-regression. another example below

model <- svm(x,y)
predictedy <- predict(model, x)
#looks like svm kicks out N/A and there is something goign on with the observations dropping for predictedy

points(y, predictedy, col = "red", pch=4)

predictedy
# predictedy seems to be a variable with probability values between 0 and 1
# make binary y out of the predicted y

binaryy <- ifelse(predictedy>0,1,0)

summary(binaryy)
summary(y)

length(y)
length(binaryy)

points(y, binaryy, col = "red", pch=4)

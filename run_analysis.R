
## Create one R script called run_analysis.R that does the following:
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for each measurement.
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive activity names.
## 5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

##Checking and Loading packages

if (!require("data.table")) {
  install.packages("data.table")
}
if (!require("reshape2")) {
  install.packages("reshape2")
}
if (!require("plyr")) {
  install.packages("plyr")
}
require("data.table")
require("reshape2")
require(plyr)

## Input training and testing datasets

X.test <- read.table("C:/Users/njiang/Desktop/UCI HAR Dataset/test/X_test.txt")
y.test <- read.table("C:/Users/njiang/Desktop/UCI HAR Dataset/test/y_test.txt")
subject.test <- read.table("C:/Users/njiang/Desktop/UCI HAR Dataset/test/subject_test.txt")

X.train <- read.table("C:/Users/njiang/Desktop/UCI HAR Dataset/train/X_train.txt")
y.train <- read.table("C:/Users/njiang/Desktop/UCI HAR Dataset/train/y_train.txt")
subject.train <- read.table("C:/Users/njiang/Desktop/UCI HAR Dataset/train/subject_train.txt")

## Input labeling info

activity.labels <- read.table("C:/Users/njiang/Desktop/UCI HAR Dataset/activity_labels.txt")[,2]

## Input data column names

features <- read.table("C:/Users/njiang/Desktop/UCI HAR Dataset/features.txt")[,2]

features<- gsub("tBody", "Time.Body", features)
features<- gsub("tGravity", "Time.Gravity", features)
features<- gsub("fBody", "FFT.Body", features)
features<- gsub("fGravity", "FFT.Gravity", features)
extract.features <- grepl("mean|std", features)

## Attach activity label for y dataset

y.train[,2] = activity.labels[y.train[,1]]
y.test[,2] = activity.labels[y.test[,1]]

## Change the column names for datasets

colnames(X.train) = features 
colnames(X.test) = features 
colnames(y.train) = c("Activity_ID","Activity_Label") 
colnames(y.test) =  c("Activity_ID","Activity_Label") 
colnames(subject.train) = "SubjectID"
colnames(subject.test) = "SubjectID"

## Subset the X datasets to mean/std measures

X.train <- X.train[,extract.features]
X.test <- X.test[,extract.features]

## Merge x, y and subject datasets

train <- cbind(X.train, y.train, subject.train)
test <- cbind(X.test, y.test, subject.test)

## Merge training and testing datasets

total <- rbind(train, test)
write.table(total, "C:/Users/njiang/Documents/GitHub/Getting and Cleaning Data Course Project/Finaldataset.csv",row.names=F)

## Create summary data table with mean values for each measure

Final.mean <- ddply(total[colnames(total)!="Activity_ID"], c("SubjectID","Activity_Label"), numcolwise(mean))
write.table(Final.mean, "C:/Users/njiang/Documents/GitHub/Getting and Cleaning Data Course Project/Finalmean.csv",row.names=F)













# run_analysis.R
# by Michael Coote
#  1. Merges the training and the test sets to create one data set.
#  2. Extracts only the measurements on the mean and standard deviation for each measurement.
#  3. Uses descriptive activity names to name the activities in the data set
#  4. Appropriately labels the data set with descriptive variable names.
#  5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

library(dplyr)

## read data sets
# working directory must contain the directory "UCI data" and all accompanying data
# using file.path to allow for windows/linux system compatiblity
print("It is assumed the working directory contains the directory UCI HAR Dataset.")

# read and clean features
filepath <- file.path("UCI HAR Dataset","features.txt")
features <- read.table(filepath,sep=" ",col.names=c("column","variable"),stringsAsFactors = FALSE)
features_desired <- features[grep("mean[()]|std[()]",features$variable),] # for grabbing only mean and std variables
features_desired$variable <- gsub("-|[(]|[)]|,","",features_desired$variable) # cleanup feature names
features$variable <- gsub("-|[(]|[)]|,","",features$variable) # cleanup feature names

# read test and train data
filepath <- file.path("UCI HAR Dataset","test","X_test.txt")
X_test <- read.table(filepath,col.names=features$variable)
filepath <- file.path("UCI HAR Dataset","test","y_test.txt")
Y_test <- read.table(filepath,col.names=c("activity"))
filepath <- file.path("UCI HAR Dataset","train","X_train.txt")
X_train <- read.table(filepath,col.names=features$variable)
filepath <- file.path("UCI HAR Dataset","train","y_train.txt")
Y_train <- read.table(filepath,col.names=c("activity"))
filepath <- file.path("UCI HAR Dataset","test","subject_test.txt")
subject_test <- read.table(filepath,col.names=c("subject"))
filepath <- file.path("UCI HAR Dataset","train","subject_train.txt")
subject_train <- read.table(filepath,col.names=c("subject"))

# create activity code lookups for converting to text descriptions
activities <- c("WALKING","WALKING_UPSTAIRS","WALKING_DOWNSTAIRS","SITTING","STANDING","LAYING")
names(activities) <- c(1,2,3,4,5,6)
for(i in seq(nrow(Y_test))) {
        Y_test$activity_name[i] <- activities[Y_test$activity[i]]
}
for(i in seq(nrow(Y_train))) {
        Y_train$activity_name[i] <- activities[Y_train$activity[i]]
}

# merge activity and subject columns
X_test$activity <- Y_test$activity_name # col 562
X_train$activity <- Y_train$activity_name
X_test$subject <- subject_test$subject # col 563
X_train$subject <- subject_train$subject

# include subject and activity columns in features
features_desired[nrow(features_desired)+1,] <- c(562,"activity")
features_desired[nrow(features_desired)+1,] <- c(563,"subject")

# get desired features only
X_test_desired <- X_test[,features_desired$variable]
X_train_desired <- X_train[,features_desired$variable]

# merge test and train for desired columns only
X <- merge(X_test_desired,X_train_desired, all=TRUE)

# group by for average of each variable for each activity and each subject
X_grouped <- group_by(X,subject,activity)
X_summary <- summarise_each(X_grouped,funs(mean)) # summary using mean for all variables not grouped

# export results
write.table(X_summary, file = "UCI_HAR_Summary.txt", quote = FALSE, row.names = FALSE)
print("Solution is stored in variable X_summary")
print("Solution is exported as space delimited text table with header to:")
filepath <- file.path(getwd(),"UCI_HAR_Summary.txt")
print(filepath)
write.table(features_desired$variable,file = "features_desired.txt", quote = FALSE, row.names = FALSE, col.names = FALSE)
print("Features used is exported as space delimited text table with header to:")
filepath <- file.path(getwd(),"features_desired.txt")
print(filepath)

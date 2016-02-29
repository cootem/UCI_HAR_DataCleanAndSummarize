## README.txt
### Created for Coursera - Getting and Cleaning Data, Week 4 Project

This repository contains a single script, run_anaysis.R, for cleaning and summarizing data for the
Human Activity Recognition Using Smartphones Dataset Version 1.0 data set.

The script accompolishes the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement.
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names.
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The working directory must contain the directory "UCI data".

The result data is stored in variable X_summary.
This summary is exported as a space delimited text table with header to a file in the working directory
called UCI_HAR_Summary.txt

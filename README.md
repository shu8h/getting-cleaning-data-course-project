# Getting and Cleaning Data Science Coursera Project

## run_analysis.R

The cleanup script (run_analysis.R) does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive activity names. 
5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 


## Process

1. Create objects indicating path of directories and files.
2. Using the the file paths , load the raw data.
3. Merge the training and test sets to create one data set ; and label columns .
4. Extract only mean and standard deviation for each measurement.
5. Using Activity Names to name the activities in the data set.
6. Labelling the data set with descriptive names.
7. Creates a second, independent tidy data set with the average of each variable for each activity and each subject. 

## Cleaned Data

The resulting clean dataset is stored by name "CleanFile.txt".
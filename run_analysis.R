library(plyr)

# Directories and files Paths
uciHard.dir <- "UCI_HAR_Dataset"
feature.file <- paste(uciHard.dir, "/features.txt", sep = "")
activity_labels.file <- paste(uciHard.dir, "/activity_labels.txt", sep = "")
x_train.file <- paste(uciHard.dir, "/train/X_train.txt", sep = "")
y_train.file <- paste(uciHard.dir, "/train/y_train.txt", sep = "")
subject_train.file <- paste(uciHard.dir, "/train/subject_train.txt", sep = "")
x_test.file  <- paste(uciHard.dir, "/test/X_test.txt", sep = "")
y_test.file  <- paste(uciHard.dir, "/test/y_test.txt", sep = "")
subject_test.file <- paste(uciHard.dir, "/test/subject_test.txt", sep = "")

# Load raw data
features <- read.table(feature.file, colClasses = c("character"))
activity_labels <- read.table(activity_labels.file, col.names = c("ActivityNo.", "Activity"))
x_train <- read.table(x_train.file)
y_train <- read.table(y_train.file)
subject_train <- read.table(subject_train.file)
x_test <- read.table(x_test.file)
y_test <- read.table(y_test.file)
subject_test <- read.table(subject_test.file)


#1. Merges the training and the test sets to create one data set.


# Binding sensor data
training.sensor.data <- cbind(cbind(x_train, subject_train), y_train)
test.sensor.data <- cbind(x_test, subject_test, y_test)
sensor.data <- rbind(training.sensor.data, test.sensor.data)

# Label columns
sensor.labels <- rbind(features, c(562, "Subject"), c(563, "ActivityNo."))[,2]
names(sensor.data) <- sensor.labels

#2. Extracts only the measurements on the mean and standard deviation for each measurement.

sensor.data.mean.std <- sensor.data[,grepl("mean|std|Subject|ActivityNo.", names(sensor.data))]

#3. Use activity names to name the activities in the data set

sensor.data.mean.std <- join(sensor.data.mean.std, activity_labels, by = "ActivityNo.", match = "first")
sensor.data.mean.std <- sensor.data.mean.std[,-1]

#4. Appropriately labels the data set with descriptive names.

# Remove parentheses
names(sensor.data.mean.std) <- gsub('\\(|\\)',"",names(sensor.data.mean.std), perl = TRUE)
# Make syntactically valid names
names(sensor.data.mean.std) <- make.names(names(sensor.data.mean.std))
# Make clearer names
names(sensor.data.mean.std) <- gsub('Acc',"Acceleration",names(sensor.data.mean.std))
names(sensor.data.mean.std) <- gsub('GyroJerk',"AngularAcceleration",names(sensor.data.mean.std))
names(sensor.data.mean.std) <- gsub('Gyro',"AngularSpeed",names(sensor.data.mean.std))
names(sensor.data.mean.std) <- gsub('Mag',"Magnitude",names(sensor.data.mean.std))
names(sensor.data.mean.std) <- gsub('^t',"TimeDomain.",names(sensor.data.mean.std))
names(sensor.data.mean.std) <- gsub('^f',"FrequencyDomain.",names(sensor.data.mean.std))
names(sensor.data.mean.std) <- gsub('\\.mean',".Mean",names(sensor.data.mean.std))
names(sensor.data.mean.std) <- gsub('\\.std',".StandardDeviation",names(sensor.data.mean.std))
names(sensor.data.mean.std) <- gsub('Freq\\.',"Frequency.",names(sensor.data.mean.std))
names(sensor.data.mean.std) <- gsub('Freq$',"Frequency",names(sensor.data.mean.std))

#5. Creates a second, independent tidy data set with the average of each variable for each activity and each subject.

clean.file = ddply(sensor.data.mean.std, c("Subject","Activity"), numcolwise(mean))
write.table(clean.file, file = "CleanFile.txt")

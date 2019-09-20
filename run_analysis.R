# Getting and cleaning data-course project

###############################################################
# set wd
###############################################################

setwd("C:/Users/Public/Dropbox (Personal)/ETELSE/coursera/data science specialization/gcd")

###############################################################
# 0. downloading and unzipping the dataset
###############################################################

if(!file.exists(".")){dir.create("./data")}
fileUrl <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(fileUrl,destfile="./Dataset.zip")

# Unzip dataSet to /data directory
unzip(zipfile="./Dataset.zip",exdir="./data")

###################################################################

###################################################################

# Reading trainings tables:

x_train <- read.table("./data/UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("./data/UCI HAR Dataset/train/y_train.txt")
subject_train <- read.table("./data/UCI HAR Dataset/train/subject_train.txt")

# Reading testing tables:
x_test <- read.table("./data/UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("./data/UCI HAR Dataset/test/y_test.txt")
subject_test <- read.table("./data/UCI HAR Dataset/test/subject_test.txt")

# Reading feature vector:
features <- read.table('./data/UCI HAR Dataset/features.txt')

# Reading activity labels:
activityLabels = read.table('./data/UCI HAR Dataset/activity_labels.txt')

# assigning column names

colnames(x_train) <- features[,2] 
colnames(y_train) <-"activityId"
colnames(subject_train) <- "subjectId"

colnames(x_test) <- features[,2] 
colnames(y_test) <- "activityId"
colnames(subject_test) <- "subjectId"

colnames(activityLabels) <- c('activityId','activityType')

###############################################################
# 1. Merging the training and the test sets to create one data set
###############################################################

mrg_train <- cbind(y_train, subject_train, x_train)
mrg_test <- cbind(y_test, subject_test, x_test)
setAllInOne <- rbind(mrg_train, mrg_test)

# Reading column names

colNames <- colnames(setAllInOne)

# Create vector for defining ID, mean and standard deviation

mean_and_std <- (grepl("activityId" , colNames) | 
                   grepl("subjectId" , colNames) | 
                   grepl("mean.." , colNames) | 
                   grepl("std.." , colNames) 
)

str(mean_and_std)
###############################################################################################
# 2. Extracting only the measurements on the mean and standard deviation for each measurement
###############################################################################################

setForMeanAndStd <- setAllInOne[ , mean_and_std == TRUE]

###############################################################################################
# 3. Using descriptive activity names to name the activities in the data set:
###############################################################################################

setWithActivityNames <- merge(setForMeanAndStd, activityLabels,
                              by='activityId',
                              all.x=TRUE)

head(setWithActivityNames)

###############################################################################################
# 4. Appropriately labels the data set with descriptive variable names
###############################################################################################

# This is done as part of the data prep for q.3

###############################################################################################
# 5. From the data set in step 4, creates a second, independent tidy data set with 
#    the average of each variable for each activity and each subject.
###############################################################################################

TidySet <- aggregate(. ~subjectId + activityId, setWithActivityNames, mean)
TidySet <- TidySet[order(TidySet$subjectId, TidySet$activityId),]
write.table(TidySet, "TidySet.txt", row.name=FALSE)





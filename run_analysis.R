### OBTIENIENDO Y LIMPIANDO DATA
### PROYECTO

### LIBRARYS REQUIRED
library(dplyr)
library(plyr)
library(reshape2)

### DOWNLOAD & READING THE DB
data.zip <- "data.zip"
url <- "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
download.file(url, destfile=data.zip)
unzip(data.zip)
file.remove(data.zip)

### PART I
activity <- read.table("UCI HAR Dataset/activity_labels.txt")
names(activity) <- c("Act_key", "Activity")
features <- read.table("UCI HAR Dataset/features.txt")

### PART II
subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt")
x_test <- read.table("UCI HAR Dataset/test/X_test.txt")
y_test <- read.table("UCI HAR Dataset/test/y_test.txt")

### PART III
subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt")
x_train <- read.table("UCI HAR Dataset/train/X_train.txt")
y_train <- read.table("UCI HAR Dataset/train/y_train.txt")

### 1. JOIN DB
x <- rbind(x_train, x_test)
y <- rbind(y_train, y_test)
colnames(y) <- "Act_key"
subject <- rbind(subject_train, subject_test)
colnames(subject) <- "Subject"

### 2. MEAN & SD VBLES
solo_m_s <- grep("std|mean|Mean", features$V2)
x_select <- x[solo_m_s]

### 3. ACTIVITY NAMES
y_full <- join(y, activity, by = "Act_key")

### 4. VARIABLE NAMES
features_select <- features$V2[solo_m_s]
colnames(x_select) <- as.vector(features_select)
data <- cbind(subject, y_full, x_select)

### 5. FINAL SUMMARY
data_melt <- melt(data, id = c("Subject", "Activity"),
                  measure.vars = as.vector(features_select))
tidy_data <- dcast(data_melt, Subject + Activity ~ variable, mean)

### EXPORT
write.table(tidy_data, "Tidy_Data.txt", row.names = F)
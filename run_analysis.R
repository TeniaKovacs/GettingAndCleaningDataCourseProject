# You should create one R script called run_analysis.R that does the following.
# 
# 1-Merges the training and the test sets to create one data set.
# 2-Extracts only the measurements on the mean and standard deviation
# for each measurement.
# 3-Uses descriptive activity names to name the activities in the data set
# 4-Appropriately labels the data set with descriptive variable names.
# 5-From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.

library(data.table)

# Read the train datasets.
X_train<-read.delim("./train/X_train.txt", sep = "", header = FALSE,stringsAsFactors = FALSE)
Y_train<-read.delim("./train/Y_train.txt", sep = "", header = FALSE,stringsAsFactors = FALSE)
subject_train<-read.delim("./train/subject_train.txt", sep = "", header = FALSE,stringsAsFactors = FALSE)


# Read the test datasets.
X_test<-read.delim("./test/X_test.txt", sep = "", header = FALSE,stringsAsFactors = FALSE)
Y_test<-read.delim("./test/Y_test.txt", sep = "", header = FALSE,stringsAsFactors = FALSE)
subject_test<-read.delim("./test/subject_test.txt", sep = "", header = FALSE,stringsAsFactors = FALSE)

# Read features and activity labels
activity_labels<-read.delim("./activity_labels.txt", sep = "", header = FALSE,stringsAsFactors = FALSE)
features<-read.delim("./features.txt", sep = "", header = FALSE,stringsAsFactors = FALSE)

# Merges the training and the test sets to create one data set.
fdata<-rbind(X_train,X_test)
ydata<-rbind(Y_train,Y_test)
sdata<-rbind(subject_train,subject_test,ydata)


# Extracts only the measurements on the mean and standard deviation for each measurement.
extract_features <- features[grep("mean\\(\\)|std\\(\\)",features[,2]),]

fdata<-fdata[,extract_features[,1]]

fdata<-cbind(fdata,sdata,ydata)
# Add labels
names(fdata)<-c(extract_features[,2],"Subject","ActivityLabels")

# Uses descriptive activity names to name the activities in the data set
fdata$ActivityLabels <- factor(fdata$ActivityLabels, levels = activity_labels[,1], labels = activity_labels[,2])

# 5-From the data set in step 4, creates a second, independent tidy data set
# with the average of each variable for each activity and each subject.
library(dplyr)
tdata<- fdata %>%
        group_by(Subject, ActivityLabels) %>%
        summarize_each(funs(mean))

write.table(tdata, file = "./tidydata.txt", row.names = FALSE, col.names = TRUE)

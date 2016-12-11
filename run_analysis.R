# run_analysis.R does the following.
# 
# - Merges the training and the test sets to create one data set.
# - Extracts only the measurements on the mean and standard deviation for each measurement.
# - Uses descriptive activity names to name the activities in the data set
# - Appropriately labels the data set with descriptive variable names.
# - From the data set in step 4, creates a second, independent tidy data set with the average - of each variable for each activity and each subject.

# load needed libraries
packages <- c("data.table", "reshape2", "dplyr")
sapply(packages, require, character.only=TRUE, quietly=TRUE)

# It assumes that working directory has been set to directory where this repository was cloned to.
getwd()

# Step 1: Merges the training and the test sets to create one data set.
dfTrain <- read.table("./data/UCI HAR Dataset/train/X_train.txt", quote="\"", comment.char="")
dfTest <- read.table("./data/UCI HAR Dataset/test/X_test.txt", quote="\"", comment.char="")
dfActivity <- rbind(dfTest,dfTrain)

# Create a vector with measurements labels (source: features.txt)
features <- read.table("./data/UCI HAR Dataset/features.txt", quote="\"", comment.char="")
rownames(features) <- features[,1]
features <- features[,2]

# Appropriately labels the data set with descriptive variable names.
names(dfActivity) <- features

# Extracts only the measurements on the mean and standard deviation for each measurement.
dfActivity <- dfActivity[,grep("(mean|std)\\(\\)",names(dfActivity), value = TRUE)]

# Uses descriptive activity names to name the activities in the data set
# files with activity codes: y_train.txt, y_test.txt
# file with activity labels: activity_labels.txt

activTrain <- read.table("./data/UCI HAR Dataset/train/y_train.txt", quote="\"", comment.char="")
activTest <- read.table("./data/UCI HAR Dataset/test/y_test.txt", quote="\"", comment.char="")
activs <- rbind(activTrain,activTest)
#rename col to "id"
names(activs) <- c("idactivity")

# convert activities to descriptives names
activLabels <- read.table("./data/UCI HAR Dataset/activity_labels.txt", quote="\"", comment.char="")
names(activLabels) <- c("idactivity","activity")

# match activities observations with their label
activs <- merge(activs,activLabels,by = "idactivity", all = TRUE)

# append activity to dataset
dfActivity <- cbind(dfActivity,activs)

# Append subject id to dataset
subjectTrain <- read.table("./data/UCI HAR Dataset/train/subject_train.txt", quote="\"", comment.char="")
subjectTest <- read.table("./data/UCI HAR Dataset/test/subject_test.txt", quote="\"", comment.char="")
subjects <- rbind(subjectTrain,subjectTest)
#rename col to "subjectid"
names(subjects) <- c("idsubject")

# append col to dataset
dfActivity <- cbind(dfActivity,subjects)
# convert idsubject to factor
dfActivity$idsubject <- factor(dfActivity$idsubject)

# create a second, independent tidy data set with the average - of each variable for each activity and each subject
# Convert from a wide to narrow data.table using the keys created earlier
dfActivityMelt <- data.table(melt(dfActivity, 
                                  id=c("idsubject", "activity"), 
                                  measure.vars = c(1:66), 
                                  variable.name = "measureCode", 
                                  value.name="measureValue"))

# Reshape the data to get the averages 
tdTidy <- dcast(dfActivityMelt, 
                idsubject + activity ~ measureCode, 
                mean, 
                value.var="measureValue")

# Write the tab delimited file
write.table(tdTidy, file="tidyData.txt", row.name=FALSE, sep = "\t")




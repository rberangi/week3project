# week3project

## run_analysis.R

## You should create one R script called run_analysis.R 
## that does the following:
 
## 1. Merges the training and the test sets to create one data set.
## 2. Extracts only the measurements on the mean and standard deviation for
##    each measurement. 
## 3. Uses descriptive activity names to name the activities in the data set
## 4. Appropriately labels the data set with descriptive variable names. 
## 5. From the data set in step 4, creates a second, 
##    independent tidy data set with the average of each variable for each
##    activity and each subject.

## ================ preprocessing ===============
require("data.table")
require("reshape") ##  needs for melt and cast functions

features <- read.table("D:/data/week3/UCI_HAR_Dataset/features.txt")[,2]
selection_index  <- grepl("mean|std", features)
activity_labels <- read.table("D:/data/week3/UCI_HAR_Dataset/activity_labels.txt")[,2]

##=========  load and process train data  ============

train_pure_data <- read.table("D:/data/week3/UCI_HAR_Dataset/train/X_train.txt") 
names(train_pure_data) = features

Extracted_train_data = train_pure_data[,selection_index]

train_activities <- read.table("D:/data/week3/UCI_HAR_Dataset/train/y_train.txt") 

train_activities[,2] = activity_labels[train_activities[,1]]
names(train_activities) = c("Activity_ID", "Activity_Label")


train_person_identifier <- read.table("D:/data/week3/UCI_HAR_Dataset/train/subject_train.txt")
names(train_person_identifier) = "person_identifier"

# --------- Bind and make train data
train_data <- cbind(as.data.table(train_person_identifier), train_activities, Extracted_train_data)

##  =========  repeat the same procedure for the test data ============

test_pure_data <- read.table("D:/data/week3/UCI_HAR_Dataset/test/X_test.txt") 
names(test_pure_data) = features

# Extract only the measurements on the mean and standard deviation for each measurement.

Extracted_test_data = test_pure_data[,selection_index]

test_activities <- read.table("D:/data/week3/UCI_HAR_Dataset/test/y_test.txt") 

test_activities[,2] = activity_labels[test_activities[,1]]
names(test_activities) = c("Activity_ID", "Activity_Label")


test_person_identifier <- read.table("D:/data/week3/UCI_HAR_Dataset/test/subject_test.txt")
names(test_person_identifier) = "person_identifier"


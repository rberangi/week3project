## analysis.R

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

##                         step 1
##  1. Please upload the tidy data set created in step 5 of the instructions. 
##  Please upload your data set as a txt file created with
##  write.table() using row.name=FALSE (do not cut and paste a
##  dataset directly into the text box, as this may cause errors saving your
##  submission).

##                         step 2
##  1. Please submit a link to a Github repo with the code for performing your
##     analysis.
##  The code should have a file run_analysis.R in the main directory that can be
##  run as long as the Samsung data is in your working directory. 
##  The output should be the tidy data set you submitted for part 1. 
##  2. You should include a README.md in the repo describing how the script works 
##  and the code book describing the variables.

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

# Bind test data
test_data <- cbind(as.data.table(test_person_identifier), test_activities, Extracted_test_data)

## ======================   Merge test and train data  ===================
data = rbind(test_data, train_data)

## ========= data averaging using melt and cast funcions 

id_labels   = c("person_identifier", "Activity_ID", "Activity_Label")

# apply melt function to make long table for averaging 

melt_data      = melt(data, id = id_labels)


# Apply mean function through cast function and rebuilt wide data table

tidy_data   = cast(melt_data, person_identifier + Activity_Label ~ variable, mean)

# save data

write.table(tidy_data, file = "D:/data/week3/tidy_data.txt", row.name=FALSE)




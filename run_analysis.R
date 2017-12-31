# This script is created in the frame of COursera "Getting and cleaning Data" course, for the Project Assignement.
# It uses data provided on the Coursera website. It is assumed that the files containing the data are located in the working directory.

library(tibble) #I use tibble in complement of dplyr, because it seems more up-to-date
library(dplyr)

# Step 1 : read the files to extract the data

X_test <- read.table("./UCI_HAR_Dataset/test/X_test.txt")
Y_test <- read.table("./UCI_HAR_Dataset/test/y_test.txt")
X_train <- read.table("./UCI_HAR_Dataset/train/X_train.txt")
Y_train <- read.table("./UCI_HAR_Dataset/train/y_train.txt")
X_colnames <- read.table("./UCI_HAR_Dataset/features.txt")
activity_labels <- read.table("./UCI_HAR_Dataset/activity_labels.txt")
X_test_subject <- read.table("./UCI_HAR_Dataset/test/subject_test.txt")
X_train_subject <- read.table("./UCI_HAR_Dataset/train/subject_train.txt")

# Step 2 : convert the data to dplyr's tbl and merge them
## Step 2.1 : convert to tibbles for ease of use
X_test_tbl <- as_tibble(X_test)
X_train_tbl <- as_tibble(X_train)
Y_test_tbl <- as_tibble(Y_test)
Y_train_tbl <- as_tibble(Y_train)
X_test_subject_tbl <- as_tibble(X_test_subject)
X_train_subject_tbl <- as_tibble(X_train_subject)

## Step 2.2 : apply column names based on data in features.txt ("Activity" and "Subject" added kind of manually)
## this is actually step 4 of the assignement but I find it useful to do it now...
colnames(X_test_tbl) <- X_colnames[,2]
colnames(X_train_tbl) <- X_colnames[,2]
colnames(Y_test_tbl) <- "Activity"
colnames(Y_train_tbl) <- "Activity"
colnames(X_test_subject_tbl) <- "Subject"
colnames(X_train_subject_tbl) <- "Subject"

## Step 2.3 : merge "type of activity" data (y_t[...].txt files) with measurement data (x_t[...].txt files),
## then with "subject" information (subject_t[...].txt information)
bind_test_tbl <- bind_cols(Y_test_tbl,X_test_tbl)
bind_test_tbl <- bind_cols(X_test_subject_tbl, bind_test_tbl)
bind_train_tbl <- bind_cols(Y_train_tbl,X_train_tbl)
bind_train_tbl <- bind_cols(X_train_subject_tbl, bind_train_tbl)

## Merge test and train datasets
bind_all_tbl <- bind_rows(bind_test_tbl,bind_train_tbl)

# Step 3: Use descriptive activity names to name the activities in the data set
## Defining a small function to identify with activity name corresond to which activity number
## based on the table in activity_labels.txt
activity <- function(x) {
  activity_labels[x,2]
}

## use this function to create a new column replacing the activity number with activity labels
bind_all_tbl <- mutate(bind_all_tbl,ActivityLabel = activity(Activity))

# Step 4 : Extract only the measurements on the mean and standard deviation for each measurement. 
## Select only the variables thatavg_all are requested : those which contains "mean" or "std"
## and columns ActivityLabel and Subject
bind_all_tbl <- select(bind_all_tbl,Subject,ActivityLabel,contains("mean"),contains("std"))

#Step 5 : Create new independant dataset with average of each variable for each activity and each subject
## First, the tbl created above are grouped by Activity and by Subject, then the mean function is applied to
## each variable using summarise_all
avg_all <- bind_all_tbl %>%
  group_by(Subject,ActivityLabel) %>%
  summarise_all(mean)

#Step 6: extract the dataset to a file
write.csv(avg_all,"./final_avg_dataset.csv",row.names=F)
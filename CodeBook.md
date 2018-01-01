##UCI\_HAR\_Dataset
*X\_[...].txt contains the measurement data
*y\_[...].txt contains the type of activity for each measurement
*subject\_[...].txt contains the data about who is the subject for each measurement

##run_analysis.r
Script written in R langage.
This script is created in the frame of COursera "Getting and cleaning Data" course, for the Project Assignement.
It uses data provided on the Coursera website. It is assumed that the files containing the data are located in the working directory.

input: text files from UCI HAR Dataset (see above)
output: final_avg_dataset.csv = text file containing tidy dataset with averaged values for each subject for each activity for the relevant variables.

###Description of the script
1.Step 1 : read the files to extract the data
All the text files contained in the UCI HAR Dataset are imported using read.table function.
1.Step 2 : convert the data to dplyr's tbl and merge them
THe data imported in step 1 are transformed to Tibble format to be easier to use later in the Script
1.1.Step 2.1 : convert to tibbles for ease of use
1.1.Step 2.2 : apply column names based on data in features.txt ("Activity" and "Subject" added kind of manually)
this is actually step 4 of the assignement but I find it useful to do it now...
1.1.Step 2.3 : merge "type of activity" data (y_t[...].txt files) with measurement data (x_t[...].txt files),
then with "subject" information (subject_t[...].txt information)
1.Step 3: Use descriptive activity names to name the activities in the data set
Defining a small function to identify with activity name corresond to which activity number
based on the table in activity_labels.txt
use this function to create a new column giving the activity labels based on activity numbers
1.Step 4 : Extract only the measurements on the mean and standard deviation for each measurement.
Select only the variables that are requested : those which contains "mean" or "std"
and columns ActivityLabel and Subject
1.Step 5 : Create new independant dataset with average of each variable for each activity and each subject
First, the tbl created above are grouped by Activity and by Subject, then the mean function is applied to
each variable using summarise\_all
1.Step 6 : extract the dataset to a file

Variables:
Subject: integer - number from 1 to n where n is the number of participants to the experiment
ActivityLabel: factor - strings describing the activity during which the measurements were taken
all other variables: double - variables extracted from UCI_HAR_Dataset, which contain "mean" or "std", averaged for each subject and for each activity.

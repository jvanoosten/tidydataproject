run_analysis.R
==============

Overview
--------

The run_analysis.R script satifies the requirements of the Getting and Cleaning Data Coursera class (https://class.coursera.org/getdata-015/) project.  The script does the following:

1. Merges the training and the test sets to create one data set.
2. Extracts only the measurements on the mean and standard deviation for each measurement. 
3. Uses descriptive activity names to name the activities in the data set
4. Appropriately labels the data set with descriptive variable names. 
5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

The sections below provide the details for each step.

The Raw Data
------------

The raw data for the project was taken from the accelerometers of the Samsung Galaxy S 
smartphone.  A full description is available at the site where the data was obtained:

http://archive.ics.uci.edu/ml/datasets/Human+Activity+Recognition+Using+Smartphones

The actual data for the project was download from here and unzipped in my working directory:

https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip 

The dataset includes the following files:

- 'README.txt': Provides information about the files.

- 'features_info.txt': Shows information about the variables used on the feature vector.

- 'features.txt': List of all features.

- 'activity_labels.txt': Links the class labels with their activity name.

- 'train/X_train.txt': Training set.

- 'train/y_train.txt': Training labels.

- 'train/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

- 'test/X_test.txt': Test set.

- 'test/y_test.txt': Test labels.

- 'test/subject_train.txt': Each row identifies the subject who performed the activity for each window sample. Its range is from 1 to 30. 

The raw data also included Inertial Signals data for both train and test but this data was 
not required in the final result therefore was not processed by the run_analysis.R script.


Merging the training and test data
----------------------------------

How the data files fit together was determined by experimenting with reading the 
files into data tables and examing there dimensions.  Later in the project, 
TA David Hood drew and nice [diagram](https://class.coursera.org/getdata-015/forum/thread?thread_id=112#comment-276) that shows how the test and training data fit together.

The script loads the features.txt in a data table so the names can be used as the 
initial column names.  

The test data is loaded into three data tables.

- Load the subject_test data table by reading subjext_test.txt. Set "subject" as the column name.
- Load the activity_test data table by reading y_test.txt. Set "activity" as the column names.
- Load the features_test data table that has all the feature variables with feature column names.

The test tables are combined using the column binding function starting with the 
subject_test, then the activity_test, and then the features_test.

The train data is loaded into three data tables.

- Load the subject_traing data table by reading subjext_train.txt. Set "subject" as the column name.
- Load the activity_train data table by reading y_train.txt. Set "activity" as the column names.
- Load the features_train data table that has all the feature variables with feature column names.

The train tables are combined using the column binding function starting with the 
subject_train, then the activity_train, and then the features_train.

The test and train data are then merged using row binding.  Duplicate columns are removed to clean the data and avoid processing errors later in the script.   The columns removed where not std() or mean() measurements.
    
Extract the mean and standard deviation measurements 
-----------------------------------------------------

Extract columns for the subject, activity, and XYZ measurements with the 
mean (*-mean()*) and standard deviation (*-std()*) functions applied.  

The freqMean measurements were excluded since they were obtained by averaging the signals 
in a signal window sample. The TA's [thread](https://class.coursera.org/getdata-015/forum/thread?thread_id=26) includes the rational for that.  Adding the *freqMean variables 
would be trivial if desired.   

The columns names to extract where determined by using boolean operations and 
the grepl function.   The extractdata data table is created by using subsetting on the 
column names. 

Uses descriptive activity names
-------------------------------

Descriptive activity names replaced the numeric value in the activity column.   

The descriptive names mapping was 1 -> "walking", 2 -> "walking up", 3 ->"walking down", 
4 -> "sitting", 5 -> "standing", and 6 -> "laying".


Label the data set with descriptive variable names
--------------------------------------------------

The lables on the variables were replaced by more descriptive names.  The sub function was 
used to remove special characters in the column names and to change std measurements to 
StdMean and mean measurements to MeanMean.  The Mean at the end is appropriate for the tidy
data which includes the average (mean) of the Std and Mean measurements. 

    
Create a second independent tidy data set
-----------------------------------------

A tidy data set with the average of each variable for each activity and each subject was 
created using the dplyr package for arranging, grouping, and summarising the data.  The 
data table is written as the tidydata.txt.   The data is in the wide form as outlined in 
this [thread](https://class.coursera.org/getdata-015/forum/thread?thread_id=27).  

The data satisifies the principles of tidy data:

1. Each variable you measure shoud be in one column
2. Each different observation of that variable shoud be in a different row
3. There should be one table for each "kind" of variable
4. If you have multiple tables, they should include a column in the table
that allows them to be linked. 

The tidy data can be viewed using these statements:

    * data <- read.table("tidydata.txt", header = TRUE)
    * View(data)

The CodeBook.md describes each variable included in the data set. 

Conclusion
----------

The project includes the four components of tidy data. 

1. The raw data - via the link. 
2. The tidy data set called tidydata.txt 
3. A code book called CodeBook.md describing each variable and its values in the tidy data set.  See 
4. The README.md that provides the recipe from going from 1 to 2,3.

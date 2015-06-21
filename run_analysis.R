run_analysis <- function() {
    # use the dplyr package for arranging, grouping, and summarising the data 
    require("dplyr")
    library(dplyr)   

    # set context to the directory that has the downloaded raw data 
    # setwd("/Users/jimvo/src/datascience/cleaningdata/project")
    
    # Instructions state the program should run if the raw data is in the working directory
    # Verify the assumption that the data is there 
    if (!file.exists("UCI HAR Dataset")) {
        # download the raw data 
        dataUrl = "https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip"
        download.file(dataUrl, destfile = "getdata_projectfiles_UCI HAR Dataset.zip", method = "curl")
        # unzip the raw data
        unzip("getdata_projectfiles_UCI HAR Dataset.zip")
    }
    
    # load the features in a table so they can be used as column names 
    features <- read.table("UCI HAR Dataset/features.txt")
    
    # Load the test data 
    # Skip loading the Inertial Signal test data since it is not going to be used 
    # Load the test subjects with a subject column name 
    subject_test <- read.table("UCI HAR Dataset/test/subject_test.txt", col.names = c("subject"))
    # Load the activity that the subjects performed with activity column name
    activity_test <- read.table("UCI HAR Dataset/test/y_test.txt", col.names = c("activity"))
    # Load the test data that has all the feature variables with feature column names 
    features_test <- read.table("UCI HAR Dataset/test/X_test.txt", 
                                col.names = as.character(features[,2]), 
                                check.names = FALSE, 
                                colClasses = "numeric",
                                comment.char = "")
    # Combine the test data columns - subject, activity, features ... 
    testdata <- cbind(subject_test, activity_test, features_test) 
    
    # Load the train data 
    # Skip loading the Inertial Signal train data since it is not going to be used 
    # Load the train subjects with a subject column name 
    subject_train <- read.table("UCI HAR Dataset/train/subject_train.txt", col.names = c("subject"))
    # Load the activity that the subjects performed with activity column name 
    activity_train <- read.table("UCI HAR Dataset/train/y_train.txt", col.names = c("activity"))
    # Load the train data that has all the feature variables with feature column names
    features_train <- read.table("UCI HAR Dataset/train/X_train.txt", 
                                 col.names = as.character(features[,2]), 
                                 check.names = FALSE,
                                 colClasses = "numeric",
                                 comment.char = "")
    
    # Skip loading the Inertial Signal data since it is not going to be extracted
    
    # Combine the train data columns - subject, activity, features ...
    traindata <- cbind(subject_train, activity_train, features_train)
    
    # 1) Merges the training and the test sets to create one data set. 
    mergedata_dup <- rbind(testdata, traindata)
    # remove duplicate named columns (they are not part of the -mean() & std() variables)
    mergedata <- mergedata_dup[!duplicated(names(mergedata_dup))]
    
    # 2) Extracts only the measurements on the mean and standard deviation for 
    # each measurement. Extract columns for the subject, activity, and XYZ measurements 
    # with the mean (*-mean()*) and standard deviation (*-std()*) functions applied.  
    # I exclude the freqMean measurements that were obtained by averaging the signals 
    # in a signal window sample.  Adding the *freqMean variables would be trivial 
    # if desired. For additional rational, see the TA's thread at 
    # https://class.coursera.org/getdata-015/forum/thread?thread_id=26
    cols <- names(mergedata)
    sacols <- cols == "subject" | cols == "activity"
    meancols <- grepl("mean", cols)
    meanfreqcols <- grepl("meanFreq", cols)
    stdcols <- grepl("std", cols)
    colsToKeep <- sacols | xor(meancols,meanfreqcols) | stdcols
    extractdata <- mergedata[colsToKeep]
    
    # 3) Uses descriptive activity names to name the activities in the data set.
    # activity_labels <- read.table("data/UCI HAR Dataset/activity_labels.txt")
    extractdata[extractdata$activity==1,2] <- "walking"
    extractdata[extractdata$activity==2,2] <- "walking up"
    extractdata[extractdata$activity==3,2] <- "walking down"
    extractdata[extractdata$activity==4,2] <- "sitting"
    extractdata[extractdata$activity==5,2] <- "standing"
    extractdata[extractdata$activity==6,2] <- "laying"
    
    # 4) Appropriately labels the data set with descriptive variable names 
    # Since the tidydata will be averages of the Std and Mean measurements, 
    # label them StdMean and MeanMean and remove the redundant Body in BodyBody.
    labels <- names(extractdata)
    labels <- sub("-std..-", 'StdMean', labels)
    labels <- sub("-std..", 'StdMean', labels)
    labels <- sub("-mean..-", 'MeanMean', labels)
    labels <- sub("-mean..", 'MeanMean', labels)
    labels <- sub("BodyBody", 'Body', labels)
    names(extractdata) <- labels
    
    # 5) From the data set in step 4, creates a second, independent tidy data set with 
    # the average of each variable for each activity and each subject.
    tidydata <- extractdata %>% arrange(subject) %>% group_by(subject, activity) %>% summarise_each(funs(mean))
    # Save the tidydata table to a file
    write.table(tidydata, "tidydata.txt", row.name=FALSE)
    
    message("The tidydata.txt file has been created and can be viewed using these statements:")
    message("data <- read.table(\"tidydata.txt\", header = TRUE)")
    message("View(data)")
}
    
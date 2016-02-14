##################################################################
# 1: Merges the training and the test sets to create one data set.
##################################################################

featureNames <- read.table("data/features.txt")

######### Loading train dir data
# Load each file of train dir into a corresponding data.frame
trainActivity <- read.table("data/train/y_train.txt", col.names = c("Activity"))
trainSubject  <- read.table("data/train/subject_train.txt", col.names = c("Subject"))
trainFeatures <- read.table("data/train/X_train.txt", col.names = featureNames$V2)
# Merge into a single data frame with cols: Activity, Subject, feature1, feature2, ...561  
trainDf <- cbind(trainActivity, trainSubject, trainFeatures)

######### Loading test dir data
# Load each file in test dir into a corresponding data.frame
testActivity <- read.table("data/test/y_test.txt", col.names = c("Activity"))
testSubject  <- read.table("data/test/subject_test.txt", col.names = c("Subject"))
testFeatures <- read.table("data/test/X_test.txt", col.names = featureNames$V2)
# Merge into a single data frame with cols: Activity, Subject, feature1, feature2, ...561  
testDf <- cbind(testActivity, testSubject, testFeatures)

# Make one single data set by appending all rows of test data.frame to train data.frame
fullDf <- rbind(trainDf, testDf)
dim(fullDf) # [1] 10299 563

############################################################################################
# 2: Extracts only the measurements on the mean and standard deviation for each measurement.
############################################################################################

# Select features named with '-mean()' and '-std()' 
# read.table replaces the following chars in column names: '-' '(' ')' by '.' 
meanAndStdDf <- fullDf %>% select(Activity, Subject, contains(".mean."), contains(".std."))
dim(meanAndStdDf) # [1] 10299 66

############################################################################
# 3: Uses descriptive activity names to name the activities in the data set.
############################################################################

# Load the activity names from file to data.frame
activityNames <- read.table("data/activity_labels.txt")

# Change Activity column from indices to factor Activity column from values 
meanAndStdDf <- meanAndStdDf %>% mutate(Activity = 
                     factor(Activity, levels=activityNames$V1,
                                      labels=activityNames$V2))

############################################################################
# 4: Appropriately labels the data set with descriptive variable names.
############################################################################

# Capitalize m of mean: transform all column names that contains 'mean' to 'Mean'
colnames(meanAndStdDf) <- gsub("mean", "Mean", colnames(meanAndStdDf))
# Capitalize s of std: transform all column names that contains 'std' to 'Std'
colnames(meanAndStdDf) <- gsub("std", "Std", colnames(meanAndStdDf))
# Remove all dots from all column names
colnames(meanAndStdDf) <- gsub("\\.", "", colnames(meanAndStdDf))
# Capitalize first letter of all columns
colnames(meanAndStdDf) <- sapply(colnames(meanAndStdDf), function(x) {
  paste(toupper(substring(x, 1,1)), substring(x, 2), sep="")
})
dim(meanAndStdDf) # [1] 10299    68

#############################################################################
# 5: From the data set in step 4, creates a second, independent tidy data set
#    with the average of each variable for each activity and each subject
#############################################################################

finalDf <- meanAndStdDf %>% 
           group_by(Activity, Subject) %>%
           summarize_each(funs(mean), -starts_with("Activity"), -starts_with("Subject"))
dim(finalDf) # [1] 180  68
head(finalDf)

# Write the final data set into a file
write.table(finalDf, "means_per_activity_per_subject.txt", row.names = FALSE)
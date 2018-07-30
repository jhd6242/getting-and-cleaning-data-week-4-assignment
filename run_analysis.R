
library(dplyr)
# test data
X_test <-   read.table("./UCI HAR Dataset/test/X_test.txt")
Y_test <-  read.table("./UCI HAR Dataset/test/y_test.txt")
Sub_test <-  read.table("./UCI HAR Dataset/test/subject_test.txt")

# training data

X_train <-  read.table("./UCI HAR Dataset/train/X_train.txt")
Y_train <-  read.table("./UCI HAR Dataset/train/y_train.txt")
Sub_train <- read.table("./UCI HAR Dataset/train/subject_train.txt")

# the features.txt file
variablename <-  read.table("./UCI HAR Dataset/features.txt")

# The activity_labels.txt file
activitylabels <-  read.table("./UCI HAR Dataset/activity_labels.txt")

# Combining  testing and training data sets

combine_X <- rbind(X_train,X_test)
combine_y <- rbind(Y_train,Y_test)
combine_sub <- rbind(Sub_train,Sub_test)

# created a data frame with just the mean and standard deviation variable names
# using variablename all rows that match in the 2nd column were subset
meanandstandard <- variablename[grep("mean\\(\\)|std\\(\\)",variablename[,2]),]

# added the variable name number to the combine_X data frame
combine_X <- combine_X[,meanandstandard[,1]]

# labels column activity
colnames(combine_y) <- "activity"
# creates a factor name activitylabel
combine_y$activitylabel  <- factor(combine_y$activity,labels = as.character(activitylabels[,2]))
# removes the 1st column and keeps all the rows
activitylabel <- combine_y[,-1]
# using the mean and standard data framesub setting the 1st column with the 2nd column of the variable name data frame
# aassigning that to the column name of combine_X
colnames(combine_X) <- variablename[meanandstandard[,1],2]

# create a 2nd tidy data set
colnames(combine_sub) <- "subject"
totals <- cbind(combine_X, activitylabel, combine_sub)

totalsmmean <- totals %>% group_by(activitylabel,subject) %>% summarize_each(funs(mean))

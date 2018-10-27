# "run_analytics.R", by Martin Leggewie (trommelmeister)
#
# Taken from the course project description:
#
# 1. Merges the training and the test sets to create one data set.
# 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
# 3. Uses descriptive activity names to name the activities in the data set
# 4. Appropriately labels the data set with descriptive variable names. 
# 5. From the data set in step 4, creates a second, independent tidy data set with the average of
#    each variable for each activity and each subject.
#
# This script applies the above steps, with one exception: It already takes step 4 in step 1,
# because ... hm, because it makes more sense to me. We already have the feature names and we can
# apply them directly while reading the data. (To be honest, in an earlier version of this script
# I had also applied step 3 in step 1, but as step 3 is a join operation it makes sense to keep
# this separate from reading and selecting the data.)
#
# Details about the final result are described in the CodeBook.md.
#
# Prerequisites for this script: The source data needs to be placed in a subfolder below the
# working directories. The name of this subfolder is defined by the data.dir variable.

library(dplyr)
data.dir <- paste(getwd(), "/data/uci_har_dataset/", sep = "")


## --------------------------------------------------------------------------------
## Part 1: "Merges the training and the test sets to create one data set."
## --------------------------------------------------------------------------------

##
## Part 1.1: Read the files common for both test and train data.
##
activity.labels <- read.fwf(file = paste(data.dir, "activity_labels.txt", sep = ""), skip = 0,
                            widths = c(2, 50), col.names = c("activity.id", "activity.name"))
features <- read.csv(file = paste(data.dir, "features.txt", sep = ""), header = FALSE, sep = " ",
                     col.names = c("feature.id", "feature.name"))

##
## Part 1.2: Read test data. 9 persons belong to the test group. Here we already use the content
##           of "features.txt" as readable names for the 561 different data variables. We also
##           provide meaningful names for the other two variables, namely for the subjects and
##           the activities. By doing so, we already met the "4. Appropriately labels the data set
##           with descriptive variable names." task, defined in the course project description.
##
subject.test <- read.csv(file = paste(data.dir, "test/subject_test.txt", sep = ""),
                         header = FALSE, col.names = (c("subject.id")))
x.test <- read.csv(file = paste(data.dir, "test/X_test.txt", sep = ""), header = FALSE, sep = "",
                   col.names = features[["feature.name"]])
y.test <- read.csv(file = paste(data.dir, "test/y_test.txt", sep = ""), header = FALSE, sep = "",
                   col.names = c("activity.id"))

##
## Part 1.3: Read train data. The remaining 21 (30 - 9) persons belong to the train group. Again,
##           we directly provide meaningful names for the 561 variables. 
##
subject.train <- read.csv(file = paste(data.dir, "train/subject_train.txt", sep = ""),
                          header = FALSE, col.names = (c("subject.id")))
x.train <- read.csv(file = paste(data.dir, "train/X_train.txt", sep = ""), header = FALSE, sep = "",
                   col.names = features[["feature.name"]])
y.train <- read.csv(file = paste(data.dir, "train/y_train.txt", sep = ""), header = FALSE, sep = "",
                    col.names = c("activity.id"))

##
## Part 1.4: Combine all previously read data. That means: We add all the in total 563 columns from
##           the three data sources subject, x, and y, for both test and train data. Once we have
##           done that, we only need to add the rows from test and train to one combined data frame.
##
combined.test <- cbind(subject.test, y.test, x.test)
combined.train <- cbind(subject.train, y.train, x.train)
combined <- rbind(combined.test, combined.train)


## -------------------------------------------------------------------------------------------------
## Part 2: "Extracts only the measurements on the mean and standard deviation for each measurement."
## -------------------------------------------------------------------------------------------------

## Select only the needed columns, i.e., mean and std columns plus the ids from the subjects and
## the activities.
extracted <- select(combined, subject.id, activity.id, matches("mean"), matches("std"))


## -------------------------------------------------------------------------------------------------
## Part 3: "Uses descriptive activity names to name the activities in the data set"
## -------------------------------------------------------------------------------------------------

## Join the activity names to the activity ids in the so-far extracted data frame. Since we want to
## avoid redundant data, we can then remove the activity ids.
## Because we already have done part 4 in step 1, we now already get the final result which we can
## use to create the tidy data set in part 5.
result <- select(merge(extracted, activity.labels, by = "activity.id", all = TRUE), -(activity.id))


## -------------------------------------------------------------------------------------------------
## Part 4: "Appropriately labels the data set with descriptive variable names."
## -------------------------------------------------------------------------------------------------

## This part is not needed because we have done this "en passant" in parts 1.2 and 1.3.


## -------------------------------------------------------------------------------------------------
## Part 5: "From the data set in step 4, creates a second, independent tidy data set with the
##          average of each variable for each activity and each subject."
## -------------------------------------------------------------------------------------------------

## To come to the requested tidy data set, we group the data by subject.id and activity.name and
## apply the mean() function to all the remaining 86 variables. To make it look a little bit nicer,
## we sort by subject.id and activity.name. Since we have 30 subjects and 6 different kind of
## activities, the resulting tidy data frame has 180 rows. To get through the finishing line, we
## save the tidy data frame as a file, using the requested "write.table() using row.name=FALSE".
tidy <- aggregate(result[colnames(result)[!grepl("subject.id|activity.name", colnames(result))]], 
                  by = result[c("subject.id","activity.name")], FUN=mean) %>%
  arrange(subject.id, activity.name)

write.table(tidy, file = "./tidy.txt", row.name = FALSE)

## That's it. Done! (I hope ...)


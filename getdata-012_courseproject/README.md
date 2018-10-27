## Course Project for "Getting and Cleaning Data" (getdata-012)


This readme descibes my solution to the course project of Coursera's "Getting and Cleaning Data" course (internal course name is "getdata-012"). As requested, all the R code needed for the project is contained in the R script file "run_analysis.R". What is not included is the Samsung test data. But if this source data is located at the needed subfolder, this script creates a file "tidy.txt" as the solution file requested by the course project description.


### What to prepare?

Before you can run the "run_analysis.R" script, there is one prerequisite step to be taken: you have to download the test data from [https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip] and unzip it to the following subfolder of your R working directory:

```
./data/uci_har_dataset
```

The script makes use of the `dplyr` package. So you have to make sure that this package is correctly installed in your R environment.


### How to start the script?

Well, since we have just one R script file, starting the script is straightforward:

```
rscript run_analysis.R
```

As I am not yet an R performance wizard, it takes a while for the script to read, change, merge, and subset the files. On my laptop (i5 2.4GHz, 4GB RAM, Win8.1 64bit) the script runs for about 45 seconds.


### What goes on inside the script?

The script more or less does what the course project's instructions "suggest".

> You should create one R script called run_analysis.R that does the following.
>
> 1. Merges the training and the test sets to create one data set.
> 2. Extracts only the measurements on the mean and standard deviation for each measurement. 
> 3. Uses descriptive activity names to name the activities in the data set
> 4. Appropriately labels the data set with descriptive variable names. 
> 5. From the data set in step 4, creates a second, independent tidy data set with the average of each variable for each activity and each subject.

For doing this, the script uses a subset of files from the provided test data, namely:

```
activity_labels.txt
features.txt
test/subject_test.txt
test/X_test.txt
test/y_test.txt
train/subject_train.txt
train/X_train.txt
train/y_train.txt
```

Now, the script operates in several steps:

1. Read the files common for both test and train data. That is, read the activity labels and the so-called features.
2. Read the three files in the `test` subfolder. Each of the files has exactly 2947 rows (and no headers). While reading the `x.test` file, the script directly applies the features as variable names for the 561 columns. 
3. Read the three files in the `train` subfolder. Each of the files has exactly 10299 rows (and no headers). Again, while reading the `x.test` file, the script directly applies the features as variable names for the 561 columns. 
4. Combine the three `test` files to one data frame. Since the three files don't have a primary key field, the script has no chance but to assume that the order in these three files fit together. Combine the three `train` files to another data frame in the same way.
5. Add the two combined files to one, putting the `train` rows below the `test` rows. Now we have one data frame with in total 563 columns (1 for the subject id, 1 for the activity id, and 561 for the actual feature values) and 10299 rows (2947 `test` rows plus 7352 `train` rows).
6. We only need the mean and standard deviation values. Therefore the script selects all the columns containing the strings "mean" and "std" plus the ones for the subject and activity ids, ignoring the letter's cases. From the 563 original columns only 88 remain.
7. We need descriptive names for the activities. For this, the script joins the names from `activity_labels.txt` to the data frame. Since we don't need the activity ids anymore, the script directly removes the activity id column from the data frame. That means, we still have a data frame with 563 columns and 10299 rows.
8. The final step: The script groups the data frame by subject ids and activity names. To the remainig 86 colums it applies the mean function. The result is ... well ... the result :-) We end up having a data frame with 180 rows (30 subjects times 6 different activities) and 88 columns. The script saves this result as file `tidy.txt` in the working directory.

More technical details are described as comments directly in the `run_analysis.R` file.


### What do I think about this course project?

Well, in general I liked this course project. From my professional experience as a software developer I can confirm that reporting tasks frequently are based on data stored in various files. From this perspective the course project is quite a good exercise for such reporting tasks.


What I didn't like so much was that I had to act like a detective and derive first how the various files from the provided test data are connected together. The description provided with the data was not too helpful. But I think this is criticism about the persons who assembled this data.



_(Martin Leggewie, 2015-03-14)_

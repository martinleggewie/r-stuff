## CodeBook for file "tidy.txt"

This code book describes the content of the file `tidy.txt`. This file is created by the R script `run_analysis.R`.

| Number | Name | Type |  Description |
|:------:|:----:|:----:|--------------|
| 1 | subject.id | integer | Number identifying the person who participated in the test. Since the provided test data is anonymized, there is no real name of the participant. There were 30 participants, hence the IDs are in the range 1:30. |
| 2 | activity.name | character | Describes the actual activity the participant has done while all the measurements have been taken. Value is one out of LAYING, SITTING, STANDING, WALKING, WALKING_DOWNSTAIRS, WALKING_UPSTAIRS |
| 3 up to 88 | (various) | numeric | Each of the 86 remaining columns contain the average value of all measurements which were contained in the test data for that specific variable, grouped by both the participants and the activities. |
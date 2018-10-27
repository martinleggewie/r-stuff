

## Q1: How many properties are worth $1Mio or more?

# Download the code book
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FPUMSDataDict06.pdf"
filename1 <- "./data/housing-in-idaho-codebook.pdf"
if (!file.exists(filename1)) {
  download.file(url = url1, destfile = filename1, method = "curl" )
}

# Download the CSV data file
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
filename2 <- "./data/housing-in-idaho.csv"
if (!file.exists(filename2)) {
  download.file(url2, filename2, method = "curl")
}

# read the data to data frame and have fun with it
data <- read.csv(filename2)

# Value of housings is stored in column "VAL" in an encoded way.
# According to the code book, value == 24 means "$1000000+".
dataOneMil <- subset(data, data$VAL == 24)

# Answer to Q1: 53
nrow(dataOneMil)



## Q2: Which of the "tidy data" principles does variable FES violate?
dataFesOnly <- data["FES"]

# Answer to Q2: Tidy data has only one variable per column. In that FES column,
# several measurements are combined in one variable, namely if husband or wife
# has work or not or if there is husband or wife present at all.



## Q3: What is the value of: sum(dat$Zip*dat$Ext,na.rm=T)

# Download the data
url3 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FDATA.gov_NGAP.xlsx"
filename3 <- "./data/natural-gas-aquisition-program.xlsx"
if (!file.exists(filename3)) {
  download.file(url = url3, destfile = filename3, method = "curl" )
}

library(xlsx)
colIndex <- 7:15
rowIndex <- 18:23
ngapData <- read.xlsx(filename3, sheetIndex = 1, header = TRUE, colIndex = colIndex, rowIndex = rowIndex)
dat <- ngapData

# Answer to Q3: 36534720
sum(dat$Zip*dat$Ext,na.rm=T)



## Q4: How many restaurants have zipcode 21231?
url4 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Frestaurants.xml"
filename4 <- "./data/baltimore-restaurants.xml"
if (!file.exists(filename4)) {
  download.file(url = url4, destfile = filename4, method = "curl" )
}

library(XML)
xmlData <- xmlTreeParse(filename4, useInternal = TRUE)
zipcodes <- xpathSApply(xmlData, "//zipcode", xmlValue)

# Answer to Q4: 127
sum(zipcodes == "21231")



## Q5: Which of the following is the fastest way to calculate the average value of the variable
##     pwgtp15 broken down by sex using the data.table package?
url5 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06pid.csv"
filename5 <- "./data/housing-in-idaho_again.csv"
if (!file.exists(filename5)) {
  download.file(url = url5, destfile = filename5, method = "curl" )
}

library(data.table)
DT <- fread(filename5)

system.time(rowMeans(DT)[DT$SEX==1])
system.time(rowMeans(DT)[DT$SEX==2])

system.time(tapply(DT$pwgtp15,DT$SEX,mean))

system.time(DT[,mean(pwgtp15),by=SEX])

system.time(mean(DT[DT$SEX==1,]$pwgtp15))
system.time(mean(DT[DT$SEX==2,]$pwgtp15))

system.time(sapply(split(DT$pwgtp15,DT$SEX),mean))

system.time(mean(DT$pwgtp15,by=DT$SEX))

# Answer to Q5 (be mere guessing): DT[,mean(pwgtp15),by=SEX]







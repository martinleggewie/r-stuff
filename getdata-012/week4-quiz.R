


## Q1: Apply strsplit() to split all the names of the data frame on the
## characters "wgtp". What is the value of the 123 element of the resulting
## list?

# if needed, download the file and read it as data frame
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
filename1 <- "./data/week4-q1.csv"
if (!file.exists(filename1)) {
  download.file(url = url1, destfile = filename1, method = "curl" )
}
data1 <- read.csv(filename1)

splitted <- strsplit(names(data1), "wgtp")
splitted[[123]]

# Answer to Q1: "" "15"




## Q2: Remove the commas from the GDP numbers in millions of dollars and average
## them. What is the average?

# if needed, download the files and read them as data frame
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
filename2 <- "./data/week4-q2.csv"
if (!file.exists(filename2)) {
  download.file(url = url2, destfile = filename2, method = "curl" )
}
data2 <- read.csv(filename2, sep = ",")

library(dplyr)
data2.tidy <- data2 %>% 
  rename(CountryCode = X,   CountryName = X.2,  GdpRank = Gross.domestic.product.2012, GdpValue = X.3) %>%
  select(CountryCode, CountryName, GdpRank, GdpValue) %>%
  mutate(GdpRankNumeric = as.numeric(as.character(GdpRank))) %>%
  filter(!is.na(GdpRankNumeric))

gdpValues <- data2.tidy[["GdpValue"]]
gdpValuesNumerical <- lapply(gdpValues, function(factor) { as.numeric(gsub(",", "", as.character(factor))) })
mean(unlist(gdpValuesNumerical))

# Answer to Q2: 377652.4




## Q3: In the data set from Question 2 what is a regular expression that would
## allow you to count the number of countries whose name begins with "United"?
## Assume that the variable with the country names in it is named countryNames.
## How many countries begin with United?

# We need the data2.tidy object from Q2.
countryNames <- data2.tidy[["CountryName"]]
length(grep("^United", countryNames))

# Answer to Q3: grep("^United",countryNames), 3




## Q4: Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
## Load the educational data from this data set: 
## https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv 
## Match the data based on the country shortcode. Of the countries for which the
## end of the fiscal year is available, how many end in June?

# if needed, download the files and read them as data frame
url4.1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
url4.2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
filename4.1 <- "./data/week4-q4.1.csv"
filename4.2 <- "./data/week4-q4.2.csv"
if (!file.exists(filename4.1)) {
  download.file(url = url4.1, destfile = filename4.1, method = "curl" )
}
if (!file.exists(filename4.2)) {
  download.file(url = url4.2, destfile = filename4.2, method = "curl" )
}
data4.1 <- read.csv(filename4.1, sep = ",")
data4.2 <- read.csv(filename4.2, sep = ",")

# make the first data set tidy ... again.
library(dplyr)
data4.1_tidy <- data4.1 %>%
  rename(CountryCode = X,   CountryName = X.2,  GdpRank = Gross.domestic.product.2012, GdpValue = X.3) %>%
  select(CountryCode, CountryName, GdpRank, GdpValue) %>%
  mutate(GdpRankNumeric = as.numeric(as.character(GdpRank))) %>%
  filter(!is.na(GdpRankNumeric))

# Join both data frames by using CountryCode as PK
data.merged <- merge(data4.1_tidy, data4.2, by = "CountryCode")

# Now, the fiscal year information is hidden as normal text in column "Special.Notes".
# Apparently, we have to search for "Fiscal year end: June".
result <- data.merged %>% filter(grepl("Fiscal year end: June", Special.Notes))
nrow(result)

# Answer to Q4: 13



## Q5: You can use the quantmod (http://www.quantmod.com/) package to get
## historical stock prices for publicly traded companies on the NASDAQ and NYSE.
## Use the following code to download data on Amazon's stock price and get the
## times the data was sampled.
## How many values were collected in 2012? How many values were collected on
## Mondays in 2012?
library(quantmod)
amzn = getSymbols("AMZN",auto.assign=FALSE)
sampleTimes = index(amzn)

library(lubridate)
sum(year(sampleTimes) == 2012)
sum((year(sampleTimes) == 2012) & (wday(sampleTimes, label = TRUE) == "Mon"))

# Answer to Q5: 250, 47





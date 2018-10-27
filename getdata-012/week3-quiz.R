

## Taken from the swirl quiz

# Some example example of how to use dplyr together with piping
library(dplyr)
cran %>%
  select(ip_id, country, package, size) %>%
  mutate(size_mb = size / 2^20) %>%
  filter(size_mb <= 0.5) %>%
  arrange(desc(size_mb))

# The following two snippets do exactly the same using dplyr, but the second does it by piping

# First snippet:
by_package <- group_by(cran, package)
pack_sum <- summarize(by_package, count = n(), unique = n_distinct(ip_id), countries = n_distinct(country), avg_bytes = mean(size))
top_countries <- filter(pack_sum, countries > 60)
result1 <- arrange(top_countries, desc(countries), avg_bytes)
print(result1)

# Second snippet
result3 <- 
  cran %>%
  group_by(package) %>%
  summarize(count = n(), unique = n_distinct(ip_id), countries = n_distinct(country), avg_bytes = mean(size)) %>%
  filter(countries > 60) %>%
  arrange(desc(countries), avg_bytes)
print(result3)


# again some snippets from the swirl quiz, this time regarding tidyr, demonstrating gather, separate, and spread
students2 %>%
  gather(sex_class, count, -grade) %>%
  separate(sex_class, c("sex", "class")) %>%
  print

students3 %>%
  gather(class, grade, class1:class5, na.rm = TRUE) %>%
  spread(test, grade) %>%
  print

sat %>%
  select(-contains("total")) %>%
  gather(part_sex, count, -score_range) %>%
  separate(part_sex, c("part", "sex")) %>%
  print

sat %>%
  select(-contains("total")) %>%
  gather(part_sex, count, -score_range) %>%
  separate(part_sex, c("part", "sex")) %>%
  group_by(part, sex) %>%
  mutate(total = sum(count), prop = count / total) %>%
  print




## Q1: What are the first 3 values of that result?

# Create a logical vector that identifies the households on greater than 10
# acres who sold more than $10,000 worth of agriculture products. Assign that
# logical vector to the variable agricultureLogical. Apply the which() function
# like this to identify the rows of the data frame where the logical vector is
# TRUE. which(agricultureLogical)

# if needed, download the file and read it as data frame
url1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2Fss06hid.csv"
filename1 <- "./data/week3-q1.csv"
if (!file.exists(filename1)) {
  download.file(url = url1, destfile = filename1, method = "curl" )
}
data1 <- read.csv(filename1)

# According to the code book, ACR == 3 means "3 .House on ten or more acres"
# and AGS == 6 means "Sales of Agriculture Products ... 6 .$10000+"
agricultureLogical <-(data1$ACR == 3) & (data1$AGS == 6)

which(agricultureLogical)
# Answer to Q1: 125, 238, 262



## Q2: Using the jpeg package read in the following picture of your instructor into R 
# https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg 
# Use the parameter native=TRUE. What are the 30th and 80th quantiles of the resulting data?

# if needed, download the file and read it as JPG
url2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fjeff.jpg"
filename2 <- "./data/week3-q2.jpg"
if (!file.exists(filename2)) {
  download.file(url = url2, destfile = filename2, method = "curl" )
}
library(jpeg)
data2 <- readJPEG(filename2, native = TRUE)

quantile(data2, probs = c(0.3, 0.8))
# Answer to Q2: -15259150 -10575416



## Q3: Load the Gross Domestic Product data for the 190 ranked countries in this data set: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv 
# Load the educational data from this data set: 
# https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv 
# Match the data based on the country shortcode. How many of the IDs match?
# Sort the data frame in descending order by GDP rank (so United States is last).
# What is the 13th country in the resulting data frame? 

# if needed, download the files and read them as data frame
url3.1 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FGDP.csv"
url3.2 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fdata%2FEDSTATS_Country.csv"
filename3.1 <- "./data/week3-q3.1.csv"
filename3.2 <- "./data/week3-q3.2.csv"
if (!file.exists(filename3.1)) {
  download.file(url = url3.1, destfile = filename3.1, method = "curl" )
}
if (!file.exists(filename3.2)) {
  download.file(url = url3.2, destfile = filename3.2, method = "curl" )
}
data3.1 <- read.csv(filename3.1, sep = ",")
data3.2 <- read.csv(filename3.2, sep = ",")

# since the first data file is definitely not tidy, let's tidy it up a little bit:
# we rename the columns, especially to have CountryCode. CountryCode is the name of the PK of
# second data file, and we are going to use for joining the two datas. Also we
# convert that GdpRank from factor to real numeric so that we can later order by this rank.
# Finally, we throw out all rows with an NA rank.
library(dplyr)
data3.1_tidy <- data3.1 %>%
  rename(CountryCode = X,   CountryName = X.2,  GdpRank = Gross.domestic.product.2012, GdpValue = X.3) %>%
  select(CountryCode, CountryName, GdpRank, GdpValue) %>%
  mutate(GdpRankNumeric = as.numeric(as.character(GdpRank))) %>%
  filter(!is.na(GdpRankNumeric))


# Join both data frames by using CountryCode as PK
data.merged <- merge(data3.1_tidy, data3.2, by = "CountryCode")

# sort by GDP in descending order
data.sortedDesc <- arrange(data.merged, desc(GdpRankNumeric))
nrow(data.sortedDesc)
data.sortedDesc[13, "CountryName"]

# Answer to Q3: "How many of the IDs match?": 189
# Answer to Q3: "What is the 13th country in the resulting data frame?": St. Kitts and Nevis




## Q4: What is the average GDP ranking for the "High income: OECD" and "High income: nonOECD" group?
# Important: We have to execute all code from Q3 before continuing here - we directly
#            depend on the data calculated in Q3.
data.highIncome.OECD <- filter(data.sorted, Income.Group == "High income: OECD")
mean(data.highIncome.OECD[["GdpRankNumeric"]])

data.highIncome.nonOECD <- filter(data.sorted, Income.Group == "High income: nonOECD")
mean(data.highIncome.nonOECD[["GdpRankNumeric"]])

# Answer to Q4: 32.96667, 91.91304



## Q5: Cut the GDP ranking into 5 separate quantile groups.
#      Make a table versus Income.Group.
#      How many countries are Lower middle income but among the 38 nations with highest GDP?
# Important: We have to execute all code from Q3 before continuing here - we directly
#            depend on the data calculated in Q3.
data.sorted <- arrange(data.merged, GdpRankNumeric)
nrow(filter(data.sorted, Income.Group == "Lower middle income" & GdpRankNumeric <= 38))

# Answer to Q5: 5
# Interesting ... we didn't need to do that "quantile groups" and "table versus Income.Group" thing.




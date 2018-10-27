

## Q1: Use this data to find the time that the datasharing repo was created.
##     What time was it created?
library(httr)

# 1. Find OAuth settings for github:
#    http://developer.github.com/v3/oauth/
oauth_endpoints("github")

# 2. Register an application at https://github.com/settings/applications;
#    Use any URL you would like for the homepage URL (http://github.com is fine)
#    and http://localhost:1410 as the callback url
#    Insert your client ID and secret below - if secret is omitted, it will
#    look it up in the GITHUB_CONSUMER_SECRET environmental variable.
myapp <- oauth_app(appname = "Getting and Cleaning Data",
                   key = "f030c798a2b2b85c277c",
                   secret = "78a5b0e8032824b1c0663826754efb5f137f985d")

# 3. Get OAuth credentials
github_token <- oauth2.0_token(oauth_endpoints("github"), myapp)

# 4. Use API
gtoken <- config(token = github_token)
req <- GET("https://api.github.com/rate_limit", gtoken)
stop_for_status(req)
content(req)





## Q4: How many characters are in the 10th, 20th, 30th and 100th lines of HTML from this page: 
##     http://biostat.jhsph.edu/~jleek/contact.html 
connection <- url("http://biostat.jhsph.edu/~jleek/contact.html")
htmlCode <- readLines(connection)
close(connection)
sapply(htmlCode[c(10, 20, 30, 100)], nchar, USE.NAMES = FALSE)

# Answer to Q4: 45 31  7 25



## Q5: Read this data set into R and report the sum of the numbers in the fourth of the nine columns.
# Download the data to local file system
url5 <- "https://d396qusza40orc.cloudfront.net/getdata%2Fwksst8110.for"
filename5 <- "./data/getdata-wksst8110.for"
if (!file.exists(filename5)) {
  download.file(url = url5, destfile = filename5, method = "curl" )
}
# read the data into data frame
data <- read.fwf(file = "./data/getdata-wksst8110.for", 
                 widths = c(15, 4, 4, 9, 4, 9, 4, 9, 4),
                 skip = 4
                 )
col4 <- data[[4]]
sum(col4)

# Answer to Q5: 32426.7

complete <- function(directory, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return a data frame of the form:
  ## id nobs
  ## 1  117
  ## 2  1041
  ## ...
  ## where 'id' is the monitor ID number and 'nobs' is the
  ## number of complete cases

  # Prepare the result
  result <- data.frame()
  
  for (i in id) {
    # construct filename from current id value
    fileName <- paste(directory, "/", sprintf("%03d.csv", i), sep = "")
    
    # load file's content into data.frame variable
    fileContent <- read.csv(fileName)
    
    # calculate number of complete cases and add this as a new row to the result
    result <- rbind(result, c(i, sum(complete.cases(fileContent))))
  }
  
  attributes(result)$names <- c("id", "nobs")
  result

}
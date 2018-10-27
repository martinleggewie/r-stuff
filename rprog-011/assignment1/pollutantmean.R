pollutantmean <- function(directory, pollutant, id = 1:332) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'pollutant' is a character vector of length 1 indicating
  ## the name of the pollutant for which we will calculate the
  ## mean; either "sulfate" or "nitrate".
  
  ## 'id' is an integer vector indicating the monitor ID numbers
  ## to be used
  
  ## Return the mean of the pollutant across all monitors list
  ## in the 'id' vector (ignoring NA values)
  
  
  # Prepare a vector to contain all pollutant non-NA data from all selected files 
  cumulatedValues <- c()
  
  # Cycle through all the selected files, find all non-NA data, add them to the
  # cumulatedValues vector. Later, when the loop is passed, we can just calculate the mean
  # by using the values stored in the cumulatedValues vector.
  for (i in id) {
    # construct filename from current id value
    fileName <- paste(directory, "/", sprintf("%03d.csv", i), sep = "")
    
    # load file's content into data.frame variable and extract the non-NA values
    fileContent <- read.csv(fileName)
    pollutantValues <- fileContent[pollutant]
    pollutantValuesNotNa <- pollutantValues[!is.na(pollutantValues)]
    
    # add all non-NA values to the cumulatedValues vector 
    cumulatedValues <- c(cumulatedValues, pollutantValuesNotNa)
  }
  
  # We have collected all necessary pollutant values. Now we can just calculate the mean
  # and return this as the result of this function. If I have understood the three example
  # tests correctly, the result should be rounded to 3 decimal places 
  round(mean(cumulatedValues), digits=3)

}
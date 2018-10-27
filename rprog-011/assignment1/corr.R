corr <- function(directory, threshold = 0) {
  ## 'directory' is a character vector of length 1 indicating
  ## the location of the CSV files
  
  ## 'threshold' is a numeric vector of length 1 indicating the
  ## number of completely observed observations (on all
  ## variables) required to compute the correlation between
  ## nitrate and sulfate; the default is 0
  
  ## Return a numeric vector of correlations
  
  
  # Prepare the result
  result <- numeric()
  
  for (fileName in list.files(directory, pattern = "csv")) {

    # Load file's content into data.frame variable.
    fileContent <- read.csv(paste(directory, "/", fileName, sep = ""))

    # Determine all non-NA values in the completeValues data.frame.
    completeValues <- fileContent[complete.cases(fileContent), ]
    
    # Only when the number of complete cases is greater than the threshold we will process the data.
    if (nrow(completeValues) > threshold) {
#      currentCor <- round(cor(completeValues$sulfate, completeValues$nitrate), digits = 5)
      currentCor <- cor(completeValues$sulfate, completeValues$nitrate)
      result <- c(result, currentCor)
    }
  }

  # We are done, return the result.
  result
  
}
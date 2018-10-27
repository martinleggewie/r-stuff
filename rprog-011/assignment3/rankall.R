rankall <- function(outcome = "", num = "best") {
  
  ## 1. Read outcome data
  outcomeData <- read.csv(file = "outcome-of-care-measures.csv",
                          colClasses = "character")  
  
  
  ## 2. Check that outcome is valid
  # 2a. Check if outcome is one of the three allowed values. For this we first
  #     prepare the mapping table which we use for both checking for valid
  #     values and later for selecting the necessary column
  mapping <- c()
  mapping["heart attack"] <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
  mapping["heart failure"] <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
  mapping["pneumonia"] <- "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
  
  if (!outcome %in% names(mapping)) {
    stop("invalid outcome")
  }
  
  # 2b. Input parameter values seem to be fine. Now let's just store the real
  #     column name for later use
  realOutcome <- mapping[[outcome]]  
  

  ## 3. For each state, find the hospital of the given rank. Return a data frame
  ##    with the hospital names and the (abbreviated) state name. The first column
  ##    in the data frame is named "hospital", the second column is named "state".
  
  # 3a. Convert just the one needed number column to real numerical values and
  #     remove the NA values.
  outcomeData[, realOutcome] <- as.numeric(outcomeData[, realOutcome])
  outcomeData <- outcomeData[complete.cases(outcomeData), ]
  
  # 3b. Convert the data frame into a list of sub data frames by splitting it
  #     by using the state. Use only the 3 out of 46 columns which we later need.
  #     After the splitting, we have the following structure: 1 list containing
  #     as many data frames as we have states. Each data frame has the needed
  #     3 columns (actually, we would need the "State" column as we have the state
  #     information already as the row name of the list.)
  outcomeDataByState <- split(outcomeData[, c("Hospital.Name", "State", realOutcome)], outcomeData$State)
  
  finder <- function(data, num) {
    sortedData <- data[order(data[realOutcome], data["Hospital.Name"]), ]
    
    realNum <- if (num == "best") {
      1
    } else if (num == "worst") {
      nrow(sortedData)
    } else {
      num
    }
    
    sortedData$Hospital.Name[realNum]
  }
  
  result = lapply(outcomeDataByState, finder, num)
  
  data.frame("hospital" = unlist(result), "state" = names(result))

}
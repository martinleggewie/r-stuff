rankhospital <- function(state = "", outcome = "", num = "best") {
  
  ## 1. Read outcome data
  outcomeData <- read.csv(file = "outcome-of-care-measures.csv",
                          colClasses = "character")
  
  
  ## 2. Check that state and outcome are valid
  # 2a. Check if given state parameter value is contained in the outcomeData
  #    at least once.
  if (!state %in% outcomeData[, "State"]) {
    stop("invalid state")
  }
  
  # 2b. Check if outcome is one of the three allowed values. For this we first
  #     prepare the mapping table which we use for both checking for valid
  #     values and later for selecting the necessary column
  mapping <- c()
  mapping["heart attack"] <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Attack"
  mapping["heart failure"] <- "Hospital.30.Day.Death..Mortality..Rates.from.Heart.Failure"
  mapping["pneumonia"] <- "Hospital.30.Day.Death..Mortality..Rates.from.Pneumonia"
  
  if (!outcome %in% names(mapping)) {
    stop("invalid outcome")
  }
  
  # 2c. Input parameter values seem to be fine. Now let's just store the real
  #     column name for later use
  realOutcome <- mapping[outcome]  
  

  ## 3. Return hospital name in that state with the given rank 30-day death rate
  # 3a. Reduce complete data with 46 columns to one with only the needed 3 cols.
  workData <- outcomeData[c("Hospital.Name", "State", realOutcome)]
  
  # 3b. Reduce workData to just these rows belonging to given state
  workData <- workData[workData[, "State"] == state, ]
  
  # 3c. Convert just the one needed number columns to real numerical values
  workData[, realOutcome] <- as.numeric(workData[, realOutcome])
  workData <- workData[complete.cases(workData), ]
  
  # 3d. We can do the first check and maybe leave the function early:
  #     If num is a numeric value and larger than the number of hospitals in that
  #     state, the function must return NA. We can do this already now.
  if (is.numeric(num) && num > nrow(workData)) {
    return(NA)
  }
  
  # 3e. num can also contain one of the two strings "best" and "worst". Let's
  #     get rid of this and calculate the real value
  realNum <- if (num == "best") {
    1
  } else if (num == "worst") {
    nrow(workData)
  } else {
    num
  }
  
  # 3f. Sort the workData by the realOutcome column so that we have the data
  #     already in the correct order. We sort first by the requested rate column
  #     and then by the hospital names.
  sortedWorkData <- workData[order(workData[realOutcome], workData["Hospital.Name"]), ]
  
  # 3g. Now we have earned the reward: Return the hospital name at the row
  #     defined by realNum.
  sortedWorkData[["Hospital.Name"]][realNum]
  
}
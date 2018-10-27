
# Helper function which
# - downloads the ZIP file containing the needed data (if file is not already there),
# - reads the CSV file in the ZIP file internally (to speed up it just reads the 2880 needed lines),
# - applies some conversion, and finally
# - returns the data.frame containing only these data needed for the various plots.
readdata <- function() {
  # 1. Download the file, if needed
  url <- "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  filename.zipped <- "exdata-data-household_power_consumption.zip"
  filename.unzipped <- "household_power_consumption.txt"
  if (!file.exists(filename.zipped)) {
    download.file(url = url, destfile = filename.zipped, method = "curl")
  }
  
  # 2. Read the data
  data.notnice <- read.table(unz(filename.zipped, filename.unzipped),
                             skip = 66637, nrows = 2880,
                             na.strings = c("?"), header = FALSE, sep = ";", dec = ".",
                             col.names = c("Date", "Time", "Global_active_power", "Global_reactive_power", "Voltage", "Global_intensity", "Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
                             colClasses = c(rep("character", 2), rep("numeric", 7)))
  
  # 3. Apply necessary conversions and filtering.
  data.nice <- data.notnice %>%
    mutate(DateTime = paste(Date, Time)) %>%
    mutate(DateTimeReal = as.POSIXct(x = DateTime, format = "%d/%m/%Y %T"))
  
  # 4. Return the data.frame for further use
  data.nice
}

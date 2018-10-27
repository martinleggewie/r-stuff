library(dplyr)
source("readdata.R")

data <- readdata()

png(filename = "plot1.png", width = 480, height = 480, units = "px")

hist(data$Global_active_power,
     xlab = "Global Active Power (kilowatts)",
     ylab = "Frequency",
     col = "red",
     main = "Global Active Power")

dev.off()

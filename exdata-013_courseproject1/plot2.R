library(dplyr)
source("readdata.R")

data <- readdata()

png(filename = "plot2.png", width = 480, height = 480, units = "px")

plot(data$DateTimeReal, 
     data$Global_active_power,
     xlab = "",
     ylab = "Global Active Power (kilowatts)",
     type = "n")
lines(data$DateTimeReal, 
      data$Global_active_power,
      type = "l")

dev.off()





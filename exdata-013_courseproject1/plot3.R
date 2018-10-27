library(dplyr)
source("readdata.R")

data <- readdata()

png(filename = "plot3.png", width = 480, height = 480, units = "px")

plot(data$DateTimeReal, 
     data$Sub_metering_1,
     xlab = "",
     ylab = "Energy sub metering",
     type = "n")
lines(data$DateTimeReal, 
      data$Sub_metering_1,
      col = "black",
      type = "l")
lines(data$DateTimeReal, 
      data$Sub_metering_2,
      col = "red",
      type = "l")
lines(data$DateTimeReal, 
      data$Sub_metering_3,
      col = "blue",
      type = "l")
legend("topright",
       lty = 1, 
       col = c("black", "red", "blue"),
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

dev.off()


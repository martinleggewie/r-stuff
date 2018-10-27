library(dplyr)
source("readdata.R")

data <- readdata()


png(filename = "plot4.png", width = 480, height = 480, units = "px")

# We want to have 2 by 2 grid for the four plots
par(mfrow = c(2, 2))

# upper left plot
plot(data$DateTimeReal, 
     data$Global_active_power,
     xlab = "",
     ylab = "Global Active Power",
     type = "n")
lines(data$DateTimeReal, 
      data$Global_active_power,
      type = "l")

# upper right plot
plot(data$DateTimeReal, 
     data$Voltage,
     xlab = "datetime",
     ylab = "Voltage",
     type = "n")
lines(data$DateTimeReal, 
      data$Voltage,
      type = "l")

# lower left plot
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
       bty = "n",
       col = c("black", "red", "blue"),
       c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"))

# lower right plot
plot(data$DateTimeReal, 
     data$Global_reactive_power,
     xlab = "datetime",
     ylab = "Global_reactive_power",
     type = "n")
lines(data$DateTimeReal, 
      data$Global_reactive_power,
      type = "l")

dev.off()


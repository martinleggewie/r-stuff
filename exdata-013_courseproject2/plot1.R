# 1. Read the data
NEI <- readRDS("summarySCC_PM25.rds")

# 2. Consolidate the data so that we can display it as a the barplot
emissions <- aggregate(NEI$Emissions, by = list(NEI$year), FUN = sum)
names(emissions) <- c("year", "pm")

# 3. Create the plot and save it as a PNG file
png(filename = "plot1.png", width = 480, height = 480, units = "px")
barplot(emissions$pm,
        names.arg = emissions$year,
        main = "PM2.5 (total, in tons)",
        xlab = "Year",
        ylab = "PM 2.5",
        col = "lightblue")
dev.off()



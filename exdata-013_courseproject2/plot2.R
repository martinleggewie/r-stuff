# 1. Read the data
NEI <- readRDS("summarySCC_PM25.rds")

# 2. Consolidate the data so that we can display it as a the barplot
NEI.baltimore <- subset(NEI, fips == "24510")
emissions.baltimore <- aggregate(NEI.baltimore$Emissions, by = list(NEI.baltimore$year), FUN = sum)
names(emissions.baltimore) <- c("year", "pm")

# 3. Create the plot and save it as a PNG file
png(filename = "plot2.png", width = 480, height = 480, units = "px")
barplot(emissions.baltimore$pm,
        names.arg = emissions.baltimore$year,
        main = "PM2.5 in Baltimore (total, in tons)",
        xlab = "Year",
        ylab = "PM 2.5",
        col = "lightgreen")
dev.off()

# 1. Read the data
NEI <- readRDS("summarySCC_PM25.rds")

# 2. Consolidate the data so that we can display it as a the barplot
NEI.baltimore.road <- subset(NEI, fips == "24510" & type == "ON-ROAD")
emissions.baltimore.road <- aggregate(NEI.baltimore.road$Emissions, by = list(NEI.baltimore.road$year), FUN = sum)
names(emissions.baltimore.road) <- c("year", "pm")

# 3. Create the plot and save it as a PNG file
png(filename = "plot5.png", width = 480, height = 480, units = "px")
barplot(emissions.baltimore.road$pm,
        names.arg = emissions.baltimore.road$year,
        main = "PM2.5 in Baltimore, ON-ROAD only (total, in tons)",
        xlab = "Year",
        ylab = "PM 2.5",
        col = "wheat")
dev.off()

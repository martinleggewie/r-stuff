# 1. Read the data
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

# 2. Filter and merge the two data frames into one which we can then directly use
SCC.coal <- SCC[grepl("Coal", SCC$SCC.Level.Three), ]
merged <- merge(x = NEI, y = SCC.coal, by = "SCC")
emissions <- aggregate(merged$Emissions, by = list(merged$year), FUN = sum)
names(emissions) <- c("year", "pm")

# 3. Create the plot and save it as a PNG file
png(filename = "plot4.png", width = 480, height = 480, units = "px")
barplot(emissions$pm,
        names.arg = emissions$year,
        main = "PM2.5 (total, coal only, in tons)",
        xlab = "Year",
        ylab = "PM 2.5",
        col = "seagreen")
dev.off()

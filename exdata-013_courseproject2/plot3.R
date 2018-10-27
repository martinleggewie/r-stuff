library(ggplot2)

# 1. Read the data
NEI <- readRDS("summarySCC_PM25.rds")

# 2. Consolidate the data so that we can display it as a the barplot
#    Since ggplot2 works best when grouping data comes as factors,
#    we convert the years and types accordingly
NEI.baltimore <- subset(NEI, fips == "24510")
NEI.baltimore$year <- factor(NEI.baltimore$year)
NEI.baltimore$type <- factor(NEI.baltimore$type)
emissions.baltimore <- aggregate(NEI.baltimore$Emissions,
                                 by = list(NEI.baltimore$year, NEI.baltimore$type),
                                 FUN = sum)
names(emissions.baltimore) <- c("year", "type", "pm")


# 3. Create the plot and save it as a PNG file
png(filename = "plot3.png", width = 640, height = 480, units = "px")
qplot(
  year, pm, data = emissions.baltimore,
  geom = "bar", fill = type, stat = "identity",
  main = "PM2.5 in Baltimore (total, by type, in tons)",
  xlab = "Year",
  ylab = "PM 2.5",
  facets = . ~ type
)
dev.off()

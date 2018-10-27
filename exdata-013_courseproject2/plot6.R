library(dplyr)
library(ggplot2)

# 1. Read the data
NEI <- readRDS("summarySCC_PM25.rds")

# 2. Consolidate the data so that we can display it as a the barplot
NEI.balt_la.road <- NEI %>%
  filter(fips == "24510" | fips == "06037") %>%
  filter(type == "ON-ROAD") %>%
  mutate(location = ifelse(fips == "24510", "Baltimore", "LA")) %>%
  group_by(year, location) %>%
  summarise(pm = sum(Emissions))

# 3. Create the plot and save it as a PNG file
png(filename = "plot6.png", width = 480, height = 480, units = "px")
qplot(
  year, pm, data = NEI.balt_la.road,
  geom = "bar", fill = location, stat = "identity",
  main = "PM2.5 in Baltimore compared to LA (total, in tons)",
  xlab = "Year",
  ylab = "PM 2.5",
  facets = . ~ location
)
dev.off()

library(dplyr)
library(ggplot2)
library(tidyr)

# Laden der CSV-Datei
filenameTracerData <- "smsproxy-lasttest_localhost_1000000_1ms_20threads_tracerdata.csv"
tracerData <- read.table(
  file = filenameTracerData,
  header = FALSE,
  sep = ",",
  skip = 1,
  na.strings = c(""),
  colClasses = c(rep("character", 9))
) %>%
  rename(timestamp = V1,
         cpu_usage_in_percent = V2,
         gc_activity_in_percent = V3,
         heap_size = V4,
         heap_used = V5,
         permgen_size = V6,
         permgen_used = V7,
         threads_live = V8,
         threads_daemon = V9) %>%
  mutate(
    timestamp = as.POSIXct(strptime(timestamp, format = "%H:%M:%OS, %d.%m.%Y")),
    cpu_usage_in_percent = as.double(gsub("\\,", ".", cpu_usage_in_percent)),
    gc_activity_in_percent = as.double(gsub("\\,", ".", gc_activity_in_percent)),
    heap_size = as.integer(gsub("\\.", "", heap_size)) / 1000000,
    heap_used = as.integer(gsub("\\.", "", heap_used)) / 1000000,
    permgen_size = as.integer(gsub("\\.", "", permgen_size)) / 1000000,
    permgen_used = as.integer(gsub("\\.", "", permgen_used)) / 1000000,
    threads_live = as.integer(threads_live),
    threads_daemon = as.integer(threads_daemon)
  )


ggplot(data=tracerData) + 
  ylim(0, 70) +
  geom_line(aes(x=timestamp, y=heap_used), colour="blue", show.legend = TRUE) +
  geom_line(aes(x=timestamp, y=heap_size), colour="red", show.legend = TRUE)


tallTracerData <- tracerData %>%
  gather(key, value, heap_size, heap_used)

subsetTallTracerData <- tallTracerData %>%
  filter(timestamp > "2017-04-12 18:00:00") %>%
  filter(timestamp < "2017-04-12 21:00:00")


ggplot(data=subsetTallTracerData) +
  ylim(0, 70) +
  geom_line(aes(x=timestamp, y=value, col=key))

ggsave(filename = "timestamp_heap.png", device = "png",
       width = 20, height = 8, units="in", dpi = 100, limitsize = FALSE)


library(dplyr)
library(ggplot2)
# library(tidyr)

# Laden der CSV-Dateien
filenameTxSigningsITan <- "data/txsignings_itan_per-minute.csv"
txSigningsITan <- read.table(
  file = filenameTxSigningsITan,
  header = TRUE,
  sep = ",",
  # nrows = 100,
  colClasses = c("character", "integer"),
  col.names = c("timestamp", "amount")
) %>%
  mutate(timestamp_minute = as.POSIXct(strptime(timestamp, format = "%Y-%m-%d - %H:%M")),
         timestamp_hour = as.POSIXct(strptime(timestamp, format = "%Y-%m-%d - %H")),
         timestamp_day = as.POSIXct(strptime(timestamp, format = "%Y-%m-%d"))       
  )

summary(txSigningsITan)
sd(txSigningsITan$amount)

txSigningsITanPerDay <- txSigningsITan %>%
  group_by(timestamp_day) %>%
  summarise(amount = sum(amount))

str(txSigningsITanPerDay)

ggplot(data=txSigningsITanPerDay, aes(x=timestamp_day, y=amount)) +
  geom_line(colour = "#0072B2", size = 1.5) +
  scale_x_datetime(date_breaks = "1 week", date_labels =  "%Y-%m-%d") +
  theme(axis.text.x = element_text(angle=60, hjust=1)) +
  ggtitle("Amount of tx signings with iTAN per day")

ggsave(filename = "amount_txsignings_itan_per-day.png", device = "png",
       width = 50, height = 10, units="in", dpi = 300, limitsize = FALSE)


filenameLoginsIbbr <- "data/logins_ibbr_per-minute.csv"
loginsIbbr <- read.table(
  file = filenameLoginsIbbr,
  header = TRUE,
  sep = ",",
  colClasses = c("character", "integer"),
  col.names = c("timestamp", "amount")
) %>%
  mutate(timestamp_minute = as.POSIXct(strptime(timestamp, format = "%Y-%m-%d - %H:%M")),
         timestamp_hour = as.POSIXct(strptime(timestamp, format = "%Y-%m-%d - %H")),
         timestamp_day = as.POSIXct(strptime(timestamp, format = "%Y-%m-%d"))
  )
         
summary(loginsIbbr)
sd(loginsIbbr$amount)

ibbrLoginsPerDay <- loginsIbbr %>%
  group_by(timestamp_day) %>%
  summarise(amount = sum(amount))

ggplot(data=ibbrLoginsPerDay, aes(x=timestamp_day, y=amount)) +
  geom_line(colour = "#009E73", size = 1.5) +
  scale_x_datetime(date_breaks = "1 week", date_labels =  "%Y-%m-%d") +
  theme(axis.text.x = element_text(angle=60, hjust=1)) +
  ggtitle("Amount of logins in IBBR per day")

ggsave(filename = "amount_logins_ibbr_per-day.png", device = "png",
       width = 50, height = 10, units="in", dpi = 300, limitsize = FALSE)


bothPerDay <-
  left_join(ibbrLoginsPerDay, txSigningsITanPerDay, by = "timestamp_day", suffix = c(".ibbr", ".itan"))

ggplot(data=bothPerDay, aes(x=timestamp_day)) +
  geom_line(aes(y=amount.ibbr), colour = "#009E73", size = 1.5) +
  geom_line(aes(y=amount.itan), colour = "#0072B2", size = 1.5) +
  scale_x_datetime(date_breaks = "1 week", date_labels =  "%Y-%m-%d") +
  theme(axis.text.x = element_text(angle=60, hjust=1)) +
  ggtitle("Amount of both logins in IBBR and tx signings with iTAN per day")

ggsave(filename = "amount_both_per-day.png", device = "png",
       width = 50, height = 10, units="in", dpi = 300, limitsize = FALSE)

# tracerData <- read.table(
#   file = filenameTracerData,
#   header = FALSE,
#   sep = ",",
#   skip = 1,
#   na.strings = c(""),
#   colClasses = c(rep("character", 9))
# ) %>%
#   rename(timestamp = V1,
#          cpu_usage_in_percent = V2,
#          gc_activity_in_percent = V3,
#          heap_size = V4,
#          heap_used = V5,
#          permgen_size = V6,
#          permgen_used = V7,
#          threads_live = V8,
#          threads_daemon = V9) %>%
#   mutate(
#     timestamp = as.POSIXct(strptime(timestamp, format = "%H:%M:%OS, %d.%m.%Y")),
#     cpu_usage_in_percent = as.double(gsub("\\,", ".", cpu_usage_in_percent)),
#     gc_activity_in_percent = as.double(gsub("\\,", ".", gc_activity_in_percent)),
#     heap_size = as.integer(gsub("\\.", "", heap_size)) / 1000000,
#     heap_used = as.integer(gsub("\\.", "", heap_used)) / 1000000,
#     permgen_size = as.integer(gsub("\\.", "", permgen_size)) / 1000000,
#     permgen_used = as.integer(gsub("\\.", "", permgen_used)) / 1000000,
#     threads_live = as.integer(threads_live),
#     threads_daemon = as.integer(threads_daemon)
#   )
# 
# 
# ggplot(data=tracerData) + 
#   ylim(0, 70) +
#   geom_line(aes(x=timestamp, y=heap_used), colour="blue", show.legend = TRUE) +
#   geom_line(aes(x=timestamp, y=heap_size), colour="red", show.legend = TRUE)
# 
# 
# tallTracerData <- tracerData %>%
#   gather(key, value, heap_size, heap_used)
# 
# subsetTallTracerData <- tallTracerData %>%
#   filter(timestamp > "2017-04-12 18:00:00") %>%
#   filter(timestamp < "2017-04-12 21:00:00")
# 
# 
# 
# 

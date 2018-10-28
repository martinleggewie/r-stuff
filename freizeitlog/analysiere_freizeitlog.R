
library(tidyr)
library(dplyr)
library(stringr)

# 1. Dateien einlesen und in einem einzigen data.frame abspeichern
freizeitlog <- data.frame()

for (filename in list.files(path = "input/", full.names = TRUE)) {
  temp <- read.table(
    file = filename,
    header = TRUE, sep = "\t", quote = "", na.strings = "",
    colClasses = c("character", "character", "numeric", "character"),
    col.names = c("datum", "beschreibung", "dauer", "schlagwort")
  )
  freizeitlog <- rbind(freizeitlog, temp)
}
rm(temp)
rm(filename)

# 2. Post-processing durchführen:
#    - Datumsangaben in echten Zeittyp umwandeln
#    - Stichwort aufsplitten in zwei, mit dem Punkt als Trennzeichen
freizeitlog <- freizeitlog %>%
  mutate(datum = as.POSIXct(x = datum, tz = "CET", format = "%Y-%m-%d")) %>%
  separate(col = schlagwort, into = c("schlagwort1", "schlagwort2"), sep = "\\.", remove = FALSE, extra = "merge")

# 3. Erste Zählungen durchführen
#    - Gesamtanzahl der Tage
n.tage <- length(unique(freizeitlog$datum))
#    - Anzahl der Tage mit Zeitangabe
n.tageMit <- length(unique((freizeitlog %>% filter(!is.na(dauer)))$datum))
#    - Anzahl der Tage ohne Zeitangabe
n.tageOhne <- length(unique((freizeitlog %>% filter(is.na(dauer)))$datum))
# - Verhältnis Tage mit Zeitangabe / Gesamtanzahl der Tage
r.tageMit.tage <- n.tageMit / n.tage 
# - Gesamtanzahl der Stunden
n.stunden <- sum(freizeitlog$dauer, na.rm = TRUE)
# - Verhältnis Gesamtanzahl Stunden / Anzahl Tage mit Zeitangabe
r.stunden.tageMit <- n.stunden / n.tageMit

# 4. Gruppieren nach den Schlagworten
g.schlagwort1 <- freizeitlog %>%
  filter(!is.na(dauer)) %>%
  group_by(schlagwort1) %>%
  summarize(dauer1 = sum(dauer), anteil = dauer1 / n.stunden)

g.schlagwort1.schlagwort2 <- freizeitlog %>%
  filter(!is.na(dauer)) %>%
  group_by(schlagwort1, schlagwort2) %>%
  summarize(dauer2 = sum(dauer), anteil = dauer2 / n.stunden) %>%
  arrange(schlagwort1, schlagwort2)



summary(freizeitlog)

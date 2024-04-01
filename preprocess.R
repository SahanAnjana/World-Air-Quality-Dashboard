<<<<<<< HEAD
library(tidyr)  
library(dplyr)

data <- read.csv("world_air_quality.csv", header = TRUE, sep = ";")


print(paste('No of null:',sum(is.na(data))))

empty_strings <- sapply(data, function(x) sum(x == ""))
print('No of empty Strings ')
print(empty_strings)

data$Country.Label[data$Country.Label == ""] <- NA
data <- data %>% mutate(Country.Label = ifelse(is.na(Country.Label), as.character(Country.Code), Country.Label))

data <- data %>% select(-City)

empty_strings <- sapply(data, function(x) sum(x == ""))
print('No of empty Strings ')
print(empty_strings)

#print(sum(is.na(df)))
print(unique(data$Pollutant[data$Unit == "ppm"]))
print(unique(data$Pollutant[data$Unit == "µg/m³"]))
print(unique(data$Pollutant[data$Unit == "particles/cm³"]))
# Remove rows with NA values
data <- na.omit(data)
# write.csv(data,"processed.csv")

=======
library(tidyr)  
library(dplyr)

data <- read.csv("world_air_quality.csv", header = TRUE, sep = ";")


print(paste('No of null:',sum(is.na(data))))

empty_strings <- sapply(data, function(x) sum(x == ""))
print('No of empty Strings ')
print(empty_strings)

data$Country.Label[data$Country.Label == ""] <- NA
data <- data %>% mutate(Country.Label = ifelse(is.na(Country.Label), as.character(Country.Code), Country.Label))

data <- data %>% select(-City)

empty_strings <- sapply(data, function(x) sum(x == ""))
print('No of empty Strings ')
print(empty_strings)

#print(sum(is.na(df)))
print(unique(data$Pollutant[data$Unit == "ppm"]))
print(unique(data$Pollutant[data$Unit == "µg/m³"]))
print(unique(data$Pollutant[data$Unit == "particles/cm³"]))
# Remove rows with NA values
data <- na.omit(data)
# write.csv(data,"processed.csv")

>>>>>>> 8c9e76a337e35f45ffdfea5907e333fd481a60bb

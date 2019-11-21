library(shiny)
library(lubridate)
library(tidyverse)
library(dplyr)

atlantic <- read.csv("atlantic.csv")
pacific <- read.csv("pacific.csv")

#merge the two data sets
globalHurricane <- rbind(atlantic, pacific)

#adding Year, Month, and Day Column as Numeric values to "globalHurricane" dataframe. Import formatting is as a factor  
globalHurricane$DateStr <- as.character(globalHurricane$Date)
globalHurricane$yearStr <- substr(as.character(globalHurricane$Date), start = 1, stop = 4)
globalHurricane$monthStr <- substr(as.character(globalHurricane$Date), start = 5, stop = 6)
globalHurricane$dayStr <- substr(as.character(globalHurricane$Date), start = 7, stop = 8)
globalHurricane$Month <- as.numeric(globalHurricane$monthStr)
globalHurricane$Year <- as.numeric(globalHurricane$yearStr)
globalHurricane$Day <- as.numeric(globalHurricane$dayStr)
globalHurricane$yearStr <- NULL
globalHurricane$monthStr <- NULL 
globalHurricane$dayStr <- NULL

write.csv(globalHurricane, file = "globalHurricane.csv")

#not enough data to track hurricanes before 1967 in a visually appealing way: this should cut off dates before 1967 and eliminate hurricanes that are unnamed
name_list_1967 <- globalHurricane %>%
  filter(Year > 1967) %>%
  filter(Name != "            UNNAMED")

write.csv(name_list_1967, file = "name_list_1967.csv")

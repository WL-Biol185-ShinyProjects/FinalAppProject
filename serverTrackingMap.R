library(shiny)
library(ggplot2)
library(gganimate)
library(tidyverse)
library(lubridate) 
library(ggmap)
library(mapdata)
library(maps)
library(dplyr)

#importing dataset to work with
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


#not enough data to track hurricanes before 1967 in a visually appealing way: this should cut off dates before 1967 and eliminate hurricanes that are unnamed
name_list_1967 <- globalHurricane %>%
  filter(Year > 1967) %>%
  filter(Name != "            UNNAMED")

server<- function(input, output) {

  input(selectedHurricane)
  
#converting a name value into a string
  selectedHurricaneData <- name_list_1967 %>%
    filter(Name = selectedHurricane)
  
#making a static hurricane tracking map (for atlantic data)
  output$staticmap <- renderplot({
  selectedHurricaneData_box <- make_bbox(lon = selectedHurricaneData$Longitude, lat = selectedHurricaneData$Latitude, f = 0.5)
  sq_map <- get_map(location = selectedHurricaneData_box, maptype = "satellite", source = "google", zoom = 5)

  staticMap <- ggmap(sq_map) +
    geom_point(data = selectedHurricaneData, mapping = aes(x = lon, y = lat, color = Maximum_Wind)) +
    geom_line(data = selectedHurricaneData, mapping = aes(x= lon, y =lat, color = Maximum_Wind)) +
    scale_color_continuous(name = "Maximum Wind Speed (mph)", low = "yellow", high = "red") +
  
#?need to fiugre out how to change title according to which hurricane was selected from drop-down box  
    labs(title = "Tracking of Hurricane X",
    x = "Longitude", y = "Latitude",
    NULL)
  })
  
}

#animated tracking map ... I think I fixed this:(need to incorporate drop-down menu so it appears as one hurricane at a time)
  animatedMap <- ggmap(sq_map) + 
    theme(text = element_text(size = 17))+
    geom_point(data = selectedHurricane, mapping = aes(x = lon, y = lat, color = Maximum_Wind)) +
    geom_line(data = selectedHurricane, mapping = aes(x = lon, y = lat, color = Maximum_Wind), size = 2) +
    scale_color_continuous(name = "Maximum Wind Speed",low = "yellow", high = "red")+
    
#?need to fiugre out how to change title according to which hurricane was selected from drop-down box 
    labs(title = "Tracking of Hurricane X",
         subtitle = "Time:{frame_time}",
          x = "Longitude", y = "Latitude", 
         transition_reveal(1,time)+
    NULL)
  
  
  


  
 
  
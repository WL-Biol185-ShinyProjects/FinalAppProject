library(shiny)
library(ggplot2)
library(gganimate)
library(tidyverse)
library(lubridate) 
library(ggmap)
library(mapdata)
library(maps)
library(dplyr)

#loading relevant csv file: all named hurricanes in both the atlantic and the pacific after the year 1967 
name_list_1967 <- read.csv("name_list_1967.csv")

server<- function(input, output) {

  input(selectedHurricane)
  
#selectedHurricane from the ui only calls the name of a hurricane, but I want the latitude and longitude associated with that hurricane across time so I need to filter out that data again
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
  
  
  


  
 
  
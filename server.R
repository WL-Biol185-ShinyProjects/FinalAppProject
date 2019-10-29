library(shiny)

#things needed for hurricane animations
require(gganimate)
require(tidyverse)
require(lubridate)
require(ggmap)
require(mapdata)
require(maps)

#importing dataset to work with
atlantic <- read.csv("https://github.com/merhiger20/FinalAppProject/blob/master/atlantic.csv")
pacific <- read.csv("https://github.com/merhiger20/FinalAppProject/blob/master/pacific.csv")

#making a static hurricane tracking map (for atlantic data)
  
atlantic_box <- make_bbox(lon = atlantic$Longitude, lat = atlantic$Latitude, f = 0.5)
sq_map <- get_map(location = atlantic_box, maptype = "satellite", source = "google", zoom = 5)

p <- ggmap(sq_map) +
    geom_point(data = atlantic, mapping = aes(x = long, y = lat, color = Maximum_Wind)) +
    geom_line(data = atlantic, mapping = aes(x= long, y =lat, color = Maximum_Wind)) +
    scale_color_continuous(name = "Maximum Wind Speed (mph)", low = "yellow", high = "red") +
  
#need to fiugre out how to change title according to which hurricane was selected from drop-down box  
    labs(title = "Tracking of Hurricane X")
    x = "Longitude", y = "Latitude", 
  NULL
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

#merge the two data sets
globalHurricane <- rbind(atlantic, pacific)

#making a static hurricane tracking map (for atlantic data)
  
globalHurricane_box <- make_bbox(lon = globalHurricane$Longitude, lat = globalHurricane$Latitude, f = 0.5)
sq_map <- get_map(location = globalHurricane_box, maptype = "satellite", source = "google", zoom = 5)

p <- ggmap(sq_map) +
    geom_point(data = globalHurricane, mapping = aes(x = long, y = lat, color = Maximum_Wind)) +
    geom_line(data = globalHurricane, mapping = aes(x= long, y =lat, color = Maximum_Wind)) +
    scale_color_continuous(name = "Maximum Wind Speed (mph)", low = "yellow", high = "red") +
  
#?need to fiugre out how to change title according to which hurricane was selected from drop-down box  
    labs(title = "Tracking of Hurricane X",
    x = "Longitude", y = "Latitude")
  NULL

#animated tracking map
  ani <- ggmap(sq_map) + 
    theme(text = element_text(size = 17))+
    geom_point(data = globalHurricane, mapping = aes(x = long, y = lat, color = Maximum_Wind)) +
    geom_line(data = globalHurricane, mapping = aes(x = long, y = lat, color = Maximum_Wind), size = 2) +
    scale_color_continuous(name = "Maximum Wind Speed",low = "yellow", high = "red")+
    
#?need to fiugre out how to change title according to which hurricane was selected from drop-down box 
    labs(title = "Tracking of Hurricane X",
         subtitle = "Time:{frame_time}",
          x = "Longitude", y = "Latitude", 
         transition_reveal(1,time)+
    NULL
    
  # embed the animation in rmarkdown. 
  animate(ani, renderer = ffmpeg_renderer())
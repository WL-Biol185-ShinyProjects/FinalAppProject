library(shiny)

#things needed for hurricane animations
require(gganimate)
require(tidyverse)
require(lubridate) #haven't mutated the time, but this package has a function to structures dates and times to different formats 
require(ggmap)
require(mapdata)
require(maps)

#importing dataset to work with
atlantic <- read.csv("https://github.com/merhiger20/FinalAppProject/blob/master/atlantic.csv")
pacific <- read.csv("https://github.com/merhiger20/FinalAppProject/blob/master/pacific.csv")

#merge the two data sets
globalHurricane <- rbind(atlantic, pacific)

#reformating data so that the 
#not enough data to track hurricanes before 1967 in a visually appealing way: this should cut off dates before 1967
name_list_1967 = (globalHurricane %>% 
                    filter(year > 1967) %>%
                    group_by(year, storm_num)  %>% 
                    select(name, year, storm_num) %>% 
                    distinct() %>% 
                    summarise(new_name = if_else(name == 'Unnamed', 
                                                 paste0('Unnamed:', storm_num, ' (', year, ')'), 
                                                 paste0(name, ' (', year,')' ))) %>% 
                    ungroup() %>%
                    distinct() %>%
                    select(new_name))[[1]]

name_list_1967 = sort(name_list_1967)

#making a static hurricane tracking map (for atlantic data)... I think I fixed this:(need to incorporate drop-down menu so it appears as one hurricane at a time)
selectedHurricane_box <- make_bbox(lon = selectedHurricane$Longitude, lat = selectedHurricane$Latitude, f = 0.5)
sq_map <- get_map(location = selectedHurricane_box, maptype = "satellite", source = "google", zoom = 5)

staticMap <- ggmap(sq_map) +
    geom_point(data = selectedHurricane, mapping = aes(x = long, y = lat, color = Maximum_Wind)) +
    geom_line(data = selectedHurricane, mapping = aes(x= long, y =lat, color = Maximum_Wind)) +
    scale_color_continuous(name = "Maximum Wind Speed (mph)", low = "yellow", high = "red") +
  
#?need to fiugre out how to change title according to which hurricane was selected from drop-down box  
    labs(title = "Tracking of Hurricane X",
    x = "Longitude", y = "Latitude",
  NULL)
staticMap

#animated tracking map ... I think I fixed this:(need to incorporate drop-down menu so it appears as one hurricane at a time)
  animatedMap <- ggmap(sq_map) + 
    theme(text = element_text(size = 17))+
    geom_point(data = selectedHurricane, mapping = aes(x = long, y = lat, color = Maximum_Wind)) +
    geom_line(data = selectedHurricane, mapping = aes(x = long, y = lat, color = Maximum_Wind), size = 2) +
    scale_color_continuous(name = "Maximum Wind Speed",low = "yellow", high = "red")+
    
#?need to fiugre out how to change title according to which hurricane was selected from drop-down box 
    labs(title = "Tracking of Hurricane X",
         subtitle = "Time:{frame_time}",
          x = "Longitude", y = "Latitude", 
         transition_reveal(1,time)+
    NULL)
    
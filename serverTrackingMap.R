library(shiny)
library(ggplot2)
library(tidyverse)
library(lubridate)
library(leaflet)
library(mapdata)
library(maps)
library(dplyr)


#loading relevant csv file: all named hurricanes in both the atlantic and the pacific after the year 1967 
name_list_1967 <- read.csv("name_list_1967.csv")

server<- function(input, output) {
  
  #making a static hurricane tracking map 
  output$staticMap <- renderLeaflet({
    
    #selectedHurricane from the ui only calls the name of a hurricane, but I want the latitude and longitude associated with that hurricane across time so I need to filter out that data again        
    selectedHurricaneData <- name_list_1967 %>%
      filter(Name == input$selectedHurricane)
    
    leaflet(data = selectedHurricaneData) %>% 
      addTiles() %>%
      addCircles(radius = 160934) 
                 
      
    
    
  })
  
}  
  
    
          
  
  
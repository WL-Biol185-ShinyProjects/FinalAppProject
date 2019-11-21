library(shiny)
library(ggplot2)
library(gganimate)
library(tidyverse)
library(lubridate) 
library(ggmap)
library(mapdata)
library(maps)
library(dplyr)

#loading relevant csv file
name_list_1967 <- read.csv("name_list_1967.csv")

ui <- fluidPage(
  
  titlePanel("Mapping Individual Hurricanes by Path and Wind Speed"),
  
  sidebarLayout(
    
    sidebarPanel(
  
      selectInput(
          inputId = "selectedHurricane",
          label = "Select a hurricane",
          choices = unique(name_list_1967$Name)
                 ),
      hr(),
      helpText("Data from National Hurricane Center") 
              ),
              
    mainPanel(
      plotOutput("staticMap")
           )
  )
)





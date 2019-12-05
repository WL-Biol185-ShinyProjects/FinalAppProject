library(shiny)
library(ggplot2)
library(tidyverse)
library(lubridate) 
library(ggmap)
library(mapdata)
library(maps)
library(dplyr)
library(leaflet)

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
          ), #closes out selectInput
          hr(),
          helpText("Data from National Hurricane Center")
      ), #closes out sidebarPanel
  
        mainPanel(
          leafletOutput("staticMap")
        ) #closes out mainPanel
    ) #closes out sidebarLayout
  ) #closes out fluidPage 







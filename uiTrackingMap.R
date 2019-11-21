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

#adding Year, Month, and Day Column as Numeric values to "globalHurricane" dataframe  

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


name_list_1967 <- globalHurricane %>%
  filter(Year > 1967) %>%
  filter(Name != "            UNNAMED")

                  

ui <- fluidPage(
  
  titlePanel("Mapping Individual Hurricanes by Path and Wind Speed"),
  
  sidebarLayout(
    
    sidebarPanel(
  
      selectInput(
          inputId = "selectedHurricane",
          label = "Select a hurricane",
          choices = unique(name_list_1967)
                 ),
      hr(),
      helpText("Data from National Hurricane Center") 
              ),
              
    mainPanel(
      plotOutput("staticMap")
           )
  )
)





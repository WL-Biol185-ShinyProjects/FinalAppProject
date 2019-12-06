library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(lubridate) 
library(dplyr)
library(leaflet)

globalHurricane <- read.csv("globalHurricane.csv")
dfHolder <- data.frame("Month" = c(1:12))
write.csv(globalHurricane, file = "globalHurricane.csv")
name_list_1967 <- globalHurricane %>%
  filter(Year > 1967) %>%
  filter(Name != "UNNAMED")
write.csv(name_list_1967, file = "name_list_1967.csv")
server <- function(input, output) {
  
  #ZEIKEL'S STUFF
  
  output$stormBar <- renderPlot({ 
    
    filteredData <- globalHurricane %>% filter(Status == input$stormType & Year == input$stormYear) 
    mergedfilteredData <- left_join(dfHolder, filteredData)
    monthNames <- c("January", "Febuary", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December")
    months <- factor(monthNames, levels = monthNames, ordered = TRUE)
    mergedfilteredData$Month <- months[mergedfilteredData$Month]
    summaryTable <- mergedfilteredData %>% group_by(Month) %>% summarise(count = n_distinct(ID, na.rm= TRUE))
    ggplot(summaryTable, aes(Month, count)) + geom_bar(stat = "identity") + coord_cartesian(ylim = c(0, 15)) + xlab("Month" ) + ylab("Number of Storms") + theme(axis.title.y = element_text(face="bold", size=20))})
  
  #BEAU'S STUFF
  #making a static hurricane tracking map 
  output$staticMap <- renderLeaflet({
    
    #selectedHurricane from the ui only calls the name of a hurricane, but I want the latitude and longitude associated with that hurricane across time so I need to filter out that data again        
    selectedHurricaneData <- name_list_1967 %>%
      filter(Name == input$selectedHurricane)
    
    pal = colorFactor(palette = c("yellow", "red"), domain = selectedHurricaneData$Maximum.WindNumeric)
    
    leaflet(data = selectedHurricaneData) %>% 
      addProviderTiles("Esri.WorldImagery") %>%
      addCircles(radius = ~Maximum.WindNumeric *1122.51429,
                 weight = 1,
                 color = ~pal(selectedHurricaneData$Maximum.WindNumeric),
                 fillColor = ~pal(selectedHurricaneData$Maximum.WindNumeric),
                 label = paste("Year=", selectedHurricaneData$Year, "Month=", selectedHurricaneData$Month, "Day=", selectedHurricaneData$Day, "Time=", selectedHurricaneData$Time)
      ) %>%
      addLegend(position = "bottomright", pal = pal,
                values = ~selectedHurricaneData$Maximum.WindNumeric, 
                title = "Max. Wind Speed (m/s)",
                opacity = 0.75)
  })
}
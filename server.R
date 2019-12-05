library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(lubridate) 
library(dplyr)
library(leaflet)

#MATT'S STUFF
#adding Date and Month Column as Numeric values to "globalHurricane" dataframe  

globalHurricane <- read.csv("globalHurricane.csv")

globalHurricane$dateStr <- as.character(globalHurricane$Date)

globalHurricane$dateStr <- substr(as.character(globalHurricane$Date), start = 1, stop = 4)

globalHurricane$monthStr <- substr(as.character(globalHurricane$Date), start = 5, stop = 6)

globalHurricane$Month <- as.numeric(globalHurricane$monthStr)

globalHurricane$Year <- as.numeric(globalHurricane$dateStr)

globalHurricane$dateStr <- NULL

globalHurricane$monthStr <- NULL 

#bulding dynamic bar graph 

# make a data frame to hold months 

dfHolder <- data.frame("Month" = c(1:12))


#BEAU'S STUFF
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

#need to convert latitude and longitude into numeric values without NSEW in order for make_bbox to recognize them; realized they are all NW points so all longitudes just need to be turned negative and latitudes can remain the same
globalHurricane$LongitudeNumWrong <- as.numeric(substr(as.character(globalHurricane$Longitude), start = 1, stop =4))
globalHurricane$lon <-  globalHurricane$LongitudeNumWrong *-1
globalHurricane$Longitude <- NULL

globalHurricane$lat <- as.numeric(substr(as.character(globalHurricane$Latitude), start = 1, stop =4))
globalHurricane$Latitude <-NULL

#need to convert max windspeed as a numeric as well
globalHurricane$Maximum.WindNumeric <- as.numeric(globalHurricane$Maximum.Wind)

write.csv(globalHurricane, file = "globalHurricane.csv")

#not enough data to track hurricanes before 1967 in a visually appealing way: this should cut off dates before 1967 and eliminate hurricanes that are unnamed
name_list_1967 <- globalHurricane %>%
  filter(Year > 1967) %>%
  filter(Name != "            UNNAMED")

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
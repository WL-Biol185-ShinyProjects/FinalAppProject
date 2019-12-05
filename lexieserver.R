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




# Define server logic to plot various variables against hurricane data ----
server <- function(input, output) {
  
  output$stormBar <- renderPlot({ 
    
    filteredData <- globalHurricane %>% filter(Status == input$stormType & Year == input$stormYear) 
    
    mergedfilteredData <- left_join(dfHolder, filteredData)
    
    summaryTable <- mergedfilteredData %>% group_by(Month) %>% summarise(count = n_distinct(ID, na.rm= TRUE)) 
    
    ggplot(summaryTable, aes(Month, count)) + geom_bar(stat = "identity") + coord_cartesian(ylim = c(0, 15)) + xlab("Month" ) + ylab("Number of Storms") + theme(axis.title.y = element_text(face="bold", size=14),                                                                                                                                                       axis.title.x = element_text(face = "bold", size = 14))
    
  })
}
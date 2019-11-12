library(shiny)


ui <- fluidPage(
  
  titlePanel("Mapping Individual Hurricanes by Path and Wind Speed"),
  
  sidebarLayout(
    
  sidebarPanel(
  
      selectInput("selectedHurricane", "Select a hurricane", choices = name_list_1967
                 ),
      hr(),
      helpText("Data from National Hurricane Center") 
              ),
              ),
  mainPanel(
    plotOutput("staticMap")
           )
    )


library(shiny)


fluidPage(
  
  titlePanel("Mapping Individual Hurricanes by Path and Wind Speed"),
  
  sidebarLayout(
    
  sidebarPanel(
  
      selectInput("selectedHurricane", "Select a hurricane", choices = globalHurricane %<% colnames(Name)
                 ),
      hr(),
      helpText("Data from... ") #need to cite the source for our data
              ),
              ),
  mainPanel(
    plotOutput("staticMap")
           )
    )


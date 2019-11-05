library(shiny)

fluidPage(
    selectInput("selectedHurricane", "Select a hurricane", choices = globalHurricane %<% pull("Name") 
               ),
   

    )
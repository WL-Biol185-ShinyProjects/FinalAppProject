library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)

  #Create dashboard 
ui <- dashboardPage(skin = "purple",
  
    header <- dashboardHeader(
      title = "History of Hurricanes"),
    
    sidebar <- dashboardSidebar(
      sidebarMenu(
        menuItem("Intro to Storms", tabName = "dashboard"),
        menuItem("Static Tracking Map", tabName = "stormMap"),
        menuItem("Storm Frequency", tabName = "stormFreq"),
        menuItem("Sources and Thank Yous", tabName = "sources"))),
    
    body <- dashboardBody(
      tabItems(
        tabItem(tabName = "dashboard",
              img(src = "giphy.gif", height = 300, width = 600),
              
              hr(),
                
              p("In a state of growing knowledge and concern regarding climate change, our app allows users to visualize the direction, severity, and frequency of major storms since 1850. It is our hope that with more data collected
                    and visualizations such as ours, we will eventually be able to predict storms based on their origin and past storm conditions."),
                    
              br(),
                
              em("Image credit to: https://giphy.com/gifs/hurricane-irma-njaAhQUJ8FGMws")),
      
        tabItem(tabName = "stormMap",
              p("Storm map content")),

        tabItem(tabName = "stormFreq",
            fluidPage(
              titlePanel("Storm Frequency Visualization"),
              sidebarLayout(
              selectizeInput("stormType", label = "Select Storm Type", choices = unique(globalHurricane$Status),
                multiple = TRUE, selected = "TS"),
              sliderInput("stormYear", label = "Year", min = 1851, max = 2015 , value = 1851, animate = animationOptions(interval = 100, loop = FALSE))),
              mainPanel(
                plotOutput("stormBar")))),
    
        tabItem(tabName = "sources",
              strong("References"),
              
              br(),
              
              p("https://giphy.com/gifs/hurricane-irma-njaAhQUJ8FGMws"),
              
              br(),
              
              p("Most importantly, thank you to Dr. Gregg Whitworth for helping us through all our coding issues, big and small. We couldn't have made this without him!")))))



shinyApp(ui, server)

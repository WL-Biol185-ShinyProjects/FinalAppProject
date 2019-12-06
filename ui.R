library(shiny)
library(shinydashboard)
library(ggplot2)
library(dplyr)
library(tidyverse)
library(lubridate) 
library(dplyr)
library(leaflet)

  #Create dashboard 
ui <- dashboardPage(skin = "purple",
  
    header <- dashboardHeader(
      title = "History of Hurricanes"),
    
    sidebar <- dashboardSidebar(
      sidebarMenu(
        menuItem("Intro to Storms",        tabName = "dashboard"),
        menuItem("Static Tracking Map",    tabName = "stormMap"),
        menuItem("Storm Frequency",        tabName = "stormFreq"),
        menuItem("Sources and Thank Yous", tabName = "sources"))),
    
    body <- dashboardBody(
      tabItems(
        tabItem(tabName = "dashboard",
              img(src = "hurricane.gif", height = 300, width = 600),
              hr(),
              p("In a state of growing knowledge and concern regarding climate change, our app allows users to visualize the direction, 
                severity, and frequency of major storms since 1850. It is our hope that with more data collected
                and visualizations such as ours, we will eventually be able to predict storms based on their origin and past storm conditions."),
              br(),
              em("Image credit to: https://giphy.com/gifs/hurricane-irma-njaAhQUJ8FGMw")),
      
        tabItem(tabName = "stormMap",
                #loading relevant csv file
                name_list_1967 <- read.csv("name_list_1967.csv"),
                fluidPage(
                  titlePanel("Mapping Individual Hurricanes by Path and Wind Speed"),
                  sidebarLayout(
                    sidebarPanel(
                      selectInput(
                        inputId = "selectedHurricane",
                        label = "Select a hurricane",
                        choices = unique(name_list_1967$Name)),
                    hr(),
                    helpText("Data from National Hurricane Center")),
                    mainPanel(
                      leafletOutput("staticMap"))))),

        tabItem(tabName = "stormFreq",
            fluidPage(
              titlePanel("Storm Frequency Visualization"),
              sidebarLayout(
                selectizeInput("stormType", label = "Select Storm Type", choices = unique(globalHurricane$Status), selected = "HU", multiple = TRUE),
              sliderInput("stormYear", label = "Year", min = 1851, max = 2015 , value = 1851, sep="" , animate = animationOptions(interval = 200, loop = FALSE))),
              sidebarPanel("We built this tool as a means to show how the frequency and spread of storms has increased over time.", width = 5),
              mainPanel(
                plotOutput("stormBar")))),
                    
        tabItem(tabName = "sources",
              strong("References"),
              br(),
              p("https://giphy.com/gifs/hurricane-irma-njaAhQUJ8FGMws"),
              br(),
              p("Most importantly, thank you to Dr. Gregg Whitworth for helping us through all our coding issues, big and small. 
                We couldn't have made this without him!")))))

shinyApp(ui, server)

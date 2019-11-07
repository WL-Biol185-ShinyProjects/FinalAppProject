library(shiny)
library(shinydashboard)

# Define UI for hurricane app ----
ui <- pageWithSidebar(
  
  # App title ----
  headerPanel("History of Hurricanes"),
  
  #Create dashboard 
  dashboardPage(
    dashboardHeader(disable = TRUE),
    sidebar <- dashboardSidebar(
      sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard"),
        menuItem("Storm Map", tabName = "stormMap",
        )
      )
    ),
    
    body <- dashboardBody(
      tabItems(
        tabItem(tabName = "dashboard",
                "Dashboard tab content"
        ),
        
        tabItem(tabName = "stormMap",
                "Storm map tab content"
        )
      )
    ),
    
    # Put them together into a dashboardPage
    dashboardPage(
      dashboardHeader(title = "Simple tabs"),
      sidebar,
      body
    )
  )
)

shinyApp(ui, server)


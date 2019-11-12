library(shiny)
library(shinydashboard)

# Define UI for hurricane app ----
ui <- pageWithSidebar(
  
  #Create dashboard 
  dashboardPage(
    dashboardHeader(),
    dashboardSidebar(
      sidebarMenu(
        menuItem("Dashboard", tabName = "dashboard"),
        menuItem("Storm Map", tabName = "stormMap")
         )
      ),
    
    title = "History of Hurricanes",
    
    dashboardBody(
      tags$head(tags$style(HTML('
      .main-header .logo {
        font-family: "Georgia", Times, "Times New Roman", serif;
        font-weight: bold;
        font-size: 24px;
      }
    '))),
      
      tabItems(
        tabItem(tabName = "dashboard",
                "In a state of growing knowledge and concern regarding climate change, our app allows users to visualize the direction and severity of major storms since 1850. It is our hope that with more data collected
                    and visualizations such as ours, we will eventually be able to predict storms based on their origin and past conditions.
                
                Image credit to: http://discovermagazine.com/2019/july/ewk-hurricanes")
        ),
        
        tabItem(tabName = "stormMap",
                "Storm map tab content",
                
          ))))
    


shinyApp(ui, server)


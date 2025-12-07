# Packages ----
library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
library(bslib)

# UI ----
ui <- fluidPage(
  
  titlePanel("Exploration des Diamants"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("prixmax",
                  "Prix maximum :",
                  min = 300,
                  max = 20000,
                  value = 500)
    ),
    
    mainPanel(
      plotOutput("distPlot")
    )
  )
)

# SERVEUR ----
server <- function(input, output) {
  
  
  
  output$distPlot <- renderPlot({
    
    ggplot(diamonds, aes(x=carat, y=price)) + geom_point()
  })
}

shinyApp(ui = ui, server = server)

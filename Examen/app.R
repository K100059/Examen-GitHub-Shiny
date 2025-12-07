# Packages ----
library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
library(bslib)
library(plotly)

# UI ----
ui <- fluidPage(
  
  theme = bs_theme(
    version = 5,
    bootswatch = "lumen"),
  
  titlePanel("Exploration des Diamants"),
  
  sidebarLayout(
    sidebarPanel(
      sliderInput("price",
                  "Prix maximum :",
                  min = 300,
                  max = 20000,
                  value = 5000),
      
      
      selectInput(inputId = "color",
                  label = "Choisir une couleur à filtrer :",
                  choices = c("D","E", "F", "G", "H", "I", "J" ),
                  selected = "D"
      ),
      
      actionButton(inputId = "bouton",
                   label = "Visualiser le graph"
      )
    ),
    
    mainPanel(
      plotlyOutput("DiamondsPlot"),
      textOutput("nombreLignes"),
      DT::DTOutput("tableau")
    )
  )
)

# SERVEUR ----
server <- function(input, output) {
  
  rv <- reactiveValues()
  
  observeEvent(input$bouton, {
    message(showNotification(
      "La valeur du slider a changé !",
      type = "message"
    ))
    
    rv$str <- diamonds |> 
      filter(price >= input$price & color == input$color)
    
    rv$nuage <- rv$str |>
      ggplot(aes(x=carat, y=price)) + 
      geom_point(
        alpha = 0.5) +
      ggtitle(paste("prix:", input$price, " & color:", input$color))
    
    
    output$DiamondsPlot <- plotly::renderPlotly({
      rv$nuage
    })
  })
}

shinyApp(ui = ui, server = server)

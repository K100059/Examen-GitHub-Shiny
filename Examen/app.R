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
      
      radioButtons(inputId = "rose",
                   label = "Colorier les points en rose ?",
                   choices = c("Oui","Non"),
                   selected = "Oui",
      ),
      
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
      paste("prix:", input$price, " & color:", input$color),
      type = "message"
    ))
    
    rv$str <- diamonds |> 
      filter(price >= input$price & color == input$color)
    
    rv$selection_couleur <- input$rose
    
    rv$nuage_noir <- rv$str |>
      ggplot(aes(x=carat, y=price)) + 
      geom_point(
        alpha = 0.5) +
      ggtitle(paste("prix:", input$price, " & color:", input$color))
    
    rv$nuage_rose<- rv$str |>
      ggplot(aes(x=carat, y=price)) + 
      geom_point(
        alpha = 0.5, 
        color = "#ffbfcb") +
      ggtitle(paste("prix:", input$price, " & color:", input$color))
    
  })
  
  
  output$DiamondsPlot <- plotly::renderPlotly({
    if (is.null(rv$nuage_rose)) {
      return(NULL)
    }
    if (rv$selection_couleur == "Oui") { 
      rv$nuage_rose 
    } else { 
      rv$nuage_noir
    }
  })
  
  
  output$tableau <- renderDT({
    rv$str
  })
  
  
}


shinyApp(ui = ui, server = server)
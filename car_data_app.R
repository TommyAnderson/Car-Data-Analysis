library(shiny)
library(ggplot2)
library(DT)
library(rsconnect)
library(readxl) 
library(RCurl)

rm(list = ls())

# data_url <- getURL("Link to github RAW")
# dataset <- read.csv(text = data_url)


setwd("C:/Users/tomma/Data332/Car Data Project/")
dataset <- read_xlsx("Car Data Collection.xlsx", .name_repair = 'universal')

column_names <- colnames(dataset)  # for input selections

ui<-fluidPage( 
  
  titlePanel(title = "Car Data For Rock Island"),
  h4(' For Rock Island, IL'),
  
  fluidRow(
    column(2,
           selectInput('X', 'Choose X',column_names,column_names[1]),
           selectInput('Y', 'Choose Y',column_names,column_names[3]),
           selectInput('Splitby', 'Split By', column_names,column_names[3])
    ),
    column(4,plotOutput('plot_01')),
    column(6,DT::dataTableOutput("table_01", width = "100%"))
  )
  
  
)

server<-function(input,output){
  
  output$plot_01 <- renderPlot({
    x_data <- dataset[[input$X]]
    y_data <- dataset[[input$Y]]

    # Check if X or Y is categorical
    is_x_cat <- is.character(x_data) || is.factor(x_data)
    is_y_cat <- is.character(y_data) || is.factor(y_data)

    # Dynamic ggplot
    p <- ggplot(dataset, aes_string(x = input$X, y = input$Y, fill = input$Splitby))

    if (is_x_cat && !is_y_cat) {
      # Categorical X, numeric Y → bar plot (e.g., average)
      p <- ggplot(dataset, aes_string(x = input$X, y = input$Y, fill = input$Splitby)) +
        stat_summary(fun = mean, geom = "bar", position = "dodge") +
        ylab(paste("Mean of", input$Y))

    } else if (!is_x_cat && is_y_cat) {
      # Numeric X, categorical Y → bar plot, swap axes
      p <- ggplot(dataset, aes_string(x = input$Y, y = input$X, fill = input$Splitby)) +
        stat_summary(fun = mean, geom = "bar", position = "dodge") +
        xlab(paste("Mean of", input$X))

    } else if (is_x_cat && is_y_cat) {
      # Both categorical → count-based bar chart
      p <- ggplot(dataset, aes_string(x = input$X, fill = input$Y)) +
        geom_bar(position = "dodge")

    } else {
      # Both numeric → scatter plot
      p <- ggplot(dataset, aes_string(x = input$X, y = input$Y, colour = input$Splitby)) +
        geom_point()
    }

    p
  })
  
  
  # output$plot_01 <- renderPlot({
  #   ggplot(dataset, aes_string(x=input$X, y=input$Y, colour=input$Splitby))+ geom_point()
  # })

  output$table_01<-DT::renderDataTable(dataset[,c(input$X,input$Y,input$Splitby)],options = list(pageLength = 4))
}

shinyApp(ui=ui, server=server)

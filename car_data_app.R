library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
library(rsconnect)
library(readxl)
library(RCurl)
library(lubridate)

rm(list = ls())

# Load and clean data
data_url <- getURL("https://raw.githubusercontent.com/TommyAnderson/Car-Data-Analysis/refs/heads/main/Car%20Data%20Collection.csv")
dataset <- read.csv(text = data_url, stringsAsFactors = FALSE)


# Standardize color labels
dataset$Color <- trimws(tolower(dataset$Color))
dataset$Color[dataset$Color %in% c("light grey", "dark grey", "grey")] <- "grey"
dataset$Color[dataset$Color %in% c("red", "maroon", "dark red")] <- "red"

# Standardize all text to lowercase
dataset <- dataset %>%
  mutate(across(where(is.character), tolower))

#convert to military time
dataset$Time <- parse_date_time(dataset$Time, orders = "I:M p")
dataset$TimeFormatted <- format(dataset$Time, "%H:%M")
dataset$Hour <- hour(dataset$Time)

# UI
column_names <- colnames(dataset)

ui <- fluidPage(
  titlePanel("Car Data For Rock Island"),
  h4("For Rock Island, IL"),
  tags$p(tags$b("Note:"), "Y-axis is always Speed"),
  
  fluidRow(
    column(2,
           selectInput('X', 'Choose X', column_names, selected = column_names[1]),
           selectInput('Splitby', 'Split By', column_names, selected = column_names[3])
    ),
    column(4,
           plotOutput('plot_01'),
           br(),
           textOutput("plot_description")
    ),
    column(6,
           DT::dataTableOutput("table_01", width = "100%")
    )
  )
)

# Server
server <- function(input, output) {
  
  output$plot_01 <- renderPlot({
    x_data <- dataset[[input$X]]
    y_data <- dataset[["Speed"]]  # Fixed Y
    
    is_x_cat <- is.character(x_data) || is.factor(x_data) ||input$X == 'Hour'
    
    # Build appropriate plot
    if (is_x_cat) {
      ggplot(dataset, aes_string(x = input$X, y = "Speed", fill = input$Splitby)) +
        stat_summary(fun = mean, geom = "bar", position = "dodge") +
        ylab("Mean Speed")
    } else {
      ggplot(dataset, aes_string(x = input$X, y = "Speed", colour = input$Splitby)) +
        geom_point() +
        ylab("Speed")
    }
  })
  
  output$plot_description <- renderText({
    paste("This plot shows Speed vs", input$X, "split by", input$Splitby)
  })
  
  output$table_01 <- DT::renderDataTable({
    DT::datatable(dataset[, c(input$X, "Speed", input$Splitby)],
                  options = list(pageLength = 4))
  })
}

# Launch app
shinyApp(ui = ui, server = server)

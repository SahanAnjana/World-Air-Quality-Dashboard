install.packages("ggplot2")
library(shiny)
library(ggplot2)
library(dplyr)
library(leaflet)

# Load data
data <- read.csv("world_air_quality.csv", header = TRUE, sep = ";")
data$Country.Label[data$Country.Label == ""] <- NA
data <- data %>% mutate(Country.Label = ifelse(is.na(Country.Label), as.character(Country.Code), Country.Label))
data <- data %>% select(-City)
data[data == ""] <- NA
data <- na.omit(data)
data$Last.Updated <- as.POSIXct(data$Last.Updated, format="%Y-%m-%dT%H:%M:%S", tz="UTC")

# Split Coordinates column into latitude and longitude
data <- data %>%
  separate(Coordinates, into = c("Latitude", "Longitude"), sep = ", ") %>%
  mutate(Latitude = as.numeric(Latitude),
         Longitude = as.numeric(Longitude))

# Filter out rows with missing or invalid lat/lon values
data <- data[complete.cases(data$Latitude, data$Longitude), ]
print(head(data))

# Define UI for application
ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%} #controls {opacity: 0.80}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(id = "controls",top = 10, right = 10,
      htmlOutput("PlotDiv")
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Update pollutant choices based on selected country
  observeEvent(input$country, {
    updateSelectInput(session, "pollutant", choices = unique(data[data$Country.Label == input$country, ]$Pollutant))
  })
  
  # Filter data based on user inputs and render histogram plot
  output$histPlot <- renderPlot({
    filtered_data <- data[data$Country.Label == input$country & data$Pollutant == input$pollutant, ]
    
    if (nrow(filtered_data) > 0) {
      ggplot(filtered_data, aes(x = Value, fill = ..count..)) +
        geom_histogram(binwidth = 10, alpha = 0.5, color = 'white') +
        labs(x = paste("Value of", input$pollutant), y = "Frequency",
             title = paste("Histogram of", input$pollutant, "in", input$country)) +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"))
    } else {
      plot(NULL, xlim = c(0, 1), ylim = c(0, 1), 
           main = "Insufficient Data", 
           xlab = "", ylab = "")
    }
  })
  
  
  # Filter data based on user inputs and render time series plot
  output$timeSeriesPlot <- renderPlot({
    filtered_data <- data[data$Country.Label == input$country & data$Pollutant == input$pollutant, ]
    
    # Check if there are enough observations to create a meaningful plot
    if (nrow(filtered_data) > 1) {
      ggplot(filtered_data, aes(x = Last.Updated, y = Value)) +
        geom_line() +
        labs(x = "Date", y = paste("Value of", input$pollutant),
             title = paste("Time Series of", input$pollutant, "in", input$country)) +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"))
    } else {
      plot(NULL, xlim = c(0, 1), ylim = c(0, 1), 
           main = "Insufficient Data", 
           xlab = "", ylab = "")
    }
  })
  
  
  # Render map
  output$map <- renderLeaflet({
    filtered_data <- data[data$Country.Label == input$country, ]
    country_coords <- filtered_data[1, c("Latitude", "Longitude")] # Coordinates of the selected country
    leaflet(data = filtered_data) %>%
      addTiles() %>%
      addMarkers(lng = ~Longitude, lat = ~Latitude, 
                 popup = ~paste("Country: ", Country.Label, "<br>",
                                "Location: ", Location, "<br>",
                                "Pollutant: ", Pollutant, "<br>",
                                "Source: ", Source.Name, "<br>",
                                "Value: ", Value,Unit, "<br>",
                                "Last Updated: ", format(Last.Updated, "%Y-%m-%d %H:%M:%S"))) %>%
      setView(lng = country_coords$Longitude, lat = country_coords$Latitude, zoom = 4)
  })
  
  
  
  # Render time series plot as HTML widget
  output$PlotDiv <- renderUI({
    tagList(
      selectInput("country", "Select Country", choices = unique(data$Country.Label)),
      selectInput("pollutant", "Select Pollutant", choices = unique(data$Pollutant)),
      plotOutput("histPlot", height = "200px", width = "300px"),
      plotOutput("timeSeriesPlot", height = "200px", width = "300px")
    ) 
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
=======
install.packages("ggplot2")
library(shiny)
library(ggplot2)
library(dplyr)
library(leaflet)

# Load data
data <- read.csv("world_air_quality.csv", header = TRUE, sep = ";")
data$Country.Label[data$Country.Label == ""] <- NA
data <- data %>% mutate(Country.Label = ifelse(is.na(Country.Label), as.character(Country.Code), Country.Label))
data <- data %>% select(-City)
data[data == ""] <- NA
data <- na.omit(data)
data$Last.Updated <- as.POSIXct(data$Last.Updated, format="%Y-%m-%dT%H:%M:%S", tz="UTC")

# Split Coordinates column into latitude and longitude
data <- data %>%
  separate(Coordinates, into = c("Latitude", "Longitude"), sep = ", ") %>%
  mutate(Latitude = as.numeric(Latitude),
         Longitude = as.numeric(Longitude))

# Filter out rows with missing or invalid lat/lon values
data <- data[complete.cases(data$Latitude, data$Longitude), ]
print(head(data))

# Define UI for application
ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width:100%;height:100%} #controls {opacity: 0.80}"),
  leafletOutput("map", width = "100%", height = "100%"),
  absolutePanel(id = "controls",top = 10, right = 10,
      htmlOutput("PlotDiv")
  )
)

# Define server logic
server <- function(input, output, session) {
  
  # Update pollutant choices based on selected country
  observeEvent(input$country, {
    updateSelectInput(session, "pollutant", choices = unique(data[data$Country.Label == input$country, ]$Pollutant))
  })
  
  # Filter data based on user inputs and render histogram plot
  output$histPlot <- renderPlot({
    filtered_data <- data[data$Country.Label == input$country & data$Pollutant == input$pollutant, ]
    
    if (nrow(filtered_data) > 0) {
      ggplot(filtered_data, aes(x = Value, fill = ..count..)) +
        geom_histogram(binwidth = 10, alpha = 0.5, color = 'white') +
        labs(x = paste("Value of", input$pollutant), y = "Frequency",
             title = paste("Histogram of", input$pollutant, "in", input$country)) +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"))
    } else {
      plot(NULL, xlim = c(0, 1), ylim = c(0, 1), 
           main = "Insufficient Data", 
           xlab = "", ylab = "")
    }
  })
  
  
  # Filter data based on user inputs and render time series plot
  output$timeSeriesPlot <- renderPlot({
    filtered_data <- data[data$Country.Label == input$country & data$Pollutant == input$pollutant, ]
    
    # Check if there are enough observations to create a meaningful plot
    if (nrow(filtered_data) > 1) {
      ggplot(filtered_data, aes(x = Last.Updated, y = Value)) +
        geom_line() +
        labs(x = "Date", y = paste("Value of", input$pollutant),
             title = paste("Time Series of", input$pollutant, "in", input$country)) +
        theme(plot.title = element_text(hjust = 0.5, face = "bold"))
    } else {
      plot(NULL, xlim = c(0, 1), ylim = c(0, 1), 
           main = "Insufficient Data", 
           xlab = "", ylab = "")
    }
  })
  
  
  # Render map
  output$map <- renderLeaflet({
    filtered_data <- data[data$Country.Label == input$country, ]
    country_coords <- filtered_data[1, c("Latitude", "Longitude")] # Coordinates of the selected country
    leaflet(data = filtered_data) %>%
      addTiles() %>%
      addMarkers(lng = ~Longitude, lat = ~Latitude, 
                 popup = ~paste("Country: ", Country.Label, "<br>",
                                "Location: ", Location, "<br>",
                                "Pollutant: ", Pollutant, "<br>",
                                "Source: ", Source.Name, "<br>",
                                "Value: ", Value,Unit, "<br>",
                                "Last Updated: ", format(Last.Updated, "%Y-%m-%d %H:%M:%S"))) %>%
      setView(lng = country_coords$Longitude, lat = country_coords$Latitude, zoom = 4)
  })
  
  
  
  # Render time series plot as HTML widget
  output$PlotDiv <- renderUI({
    tagList(
      selectInput("country", "Select Country", choices = unique(data$Country.Label)),
      selectInput("pollutant", "Select Pollutant", choices = unique(data$Pollutant)),
      plotOutput("histPlot", height = "200px", width = "300px"),
      plotOutput("timeSeriesPlot", height = "200px", width = "300px")
    ) 
    
  })
  
}

# Run the application 
shinyApp(ui = ui, server = server)
>>>>>>> 8c9e76a337e35f45ffdfea5907e333fd481a60bb

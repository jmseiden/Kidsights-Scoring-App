library(shiny)
library(KidsightsPublic)
library(shinybusy)

# Define the UI for the app
ui <- fluidPage(
  
  add_busy_gif(src = "https://jeroen.github.io/images/banana.gif", height = 70, width = 70),
  # add_busy_gif(src = "https://cdn.dribbble.com/users/707433/screenshots/6720160/gears2.gif", height = 70, width = 70),
  # add_busy_bar(),
  
  
  titlePanel("Kidsights Data Scoring App"),
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload .csv file of Kidsights data")
    ),
    mainPanel(
      tabsetPanel(
        tabPanel("Data Preview", dataTableOutput("data_preview")),
        tabPanel("Process and Download Results", downloadButton("downloadData", "Process and Download Data Output"))
      )
    )
  )
)

# Define the server logic for the app
server <- function(input, output) {
  
  # Reactive expression to read the uploaded CSV file
  uploaded_data <- reactive({
    req(input$file) # Ensure that a file is uploaded
    read.csv(input$file$datapath)
  })
  
  # Display the data preview
  output$data_preview <- renderDataTable({
    uploaded_data()
  })
  
  # Generate and download the processed data
  output$downloadData <- downloadHandler(
    filename = function() {
      paste("processed_data.csv")
    },
    content = function(file) {
      # Process the data using the fscores function
      processed_data <- fscores(uploaded_data())
      # Write the processed data to a CSV file
      write.csv(processed_data, file, row.names = FALSE)
    }
  )
}

# Run the application
shinyApp(ui = ui, server = server)
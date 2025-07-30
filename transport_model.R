library(shiny)
library(tidyverse)
library(mlogit)

ui <- fluidPage(
  titlePanel("Transport Mode Choice Prediction with mlogit"),
  
  sidebarLayout(
    sidebarPanel(
      fileInput("file", "Upload transport_data.csv", accept = ".csv"),
      actionButton("runModel", "Run Model"),
      hr(),
      verbatimTextOutput("accuracy")
    ),
    
    mainPanel(
      tabsetPanel(
        tabPanel("Model Summary", verbatimTextOutput("modelSummary")),
        tabPanel("Confusion Matrix", verbatimTextOutput("confMatrix")),
        tabPanel("Predicted Probabilities", plotOutput("probPlot"))
      )
    )
  )
)

server <- function(input, output, session) {
  data <- reactiveVal(NULL)
  model <- reactiveVal(NULL)
  pred_probs <- reactiveVal(NULL)
  results <- reactiveVal(NULL)
  
  observeEvent(input$file, {
    req(input$file)
    df <- read_csv(input$file$datapath)
    data(df)
  })
  
  observeEvent(input$runModel, {
    req(data())
    df <- data()
    
    # Convert to mlogit format
    mlogit_df <- mlogit.data(df,
                             choice = "choice",
                             shape = "wide",
                             varying = 3:8, # car_time to bike_cost
                             sep = "_",
                             id.var = "person_id")
    
    # Fit model
    mod <- mlogit(choice ~ time + cost | income, data = mlogit_df)
    model(mod)
    
    # Predict probabilities
    probs <- fitted(mod, type = "probabilities")
    pred_probs(probs)
    
    # Predicted choices
    predicted_choice <- apply(probs, 1, function(row) names(row)[which.max(row)])
    actual_choice <- df$choice
    
    results(tibble(
      actual = actual_choice,
      predicted = predicted_choice
    ))
  })
  
  output$modelSummary <- renderPrint({
    req(model())
    summary(model())
  })
  
  output$confMatrix <- renderPrint({
    req(results())
    conf_mat <- table(results()$actual, results()$predicted)
    conf_mat
  })
  
  output$accuracy <- renderText({
    req(results())
    accuracy <- mean(results()$actual == results()$predicted)
    paste("Model Accuracy:", round(accuracy * 100, 2), "%")
  })
  
  output$probPlot <- renderPlot({
    req(pred_probs())
    mean_probs <- colMeans(pred_probs())
    mean_probs_df <- enframe(mean_probs, name = "mode", value = "mean_probability")
    
    ggplot(mean_probs_df, aes(x = mode, y = mean_probability, fill = mode)) +
      geom_col(width = 0.6) +
      labs(title = "Average Predicted Probabilities by Mode",
           x = "Transport Mode",
           y = "Mean Probability") +
      theme_minimal()
  })
}

shinyApp(ui, server)

  

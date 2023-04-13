library(shiny)
library(ggplot2)

# Define a UI
ui <- fluidPage(
  # Define um titulo
  titlePanel("Scatter Plot com Cores"),
  
  # Define os inputs
  sidebarLayout(
    sidebarPanel(
      sliderInput("n_points", "Numero de pontos:", min = 10, max = 100, value = 50),
      selectInput("grupo", "Grupo:", choices = c("A", "B", "C"), selected = "A")
    ),
    mainPanel(
      # Exibe o grafico
      plotOutput("scatter_plot")
    )
  )
)

# Define o servidor
server <- function(input, output) {
  
  # Cria o grafico
  output$scatter_plot <- renderPlot({
    # Gera os dados aleatorios
    x <- rnorm(input$n_points)
    y <- rnorm(input$n_points)
    grupo <- rep(input$grupo, input$n_points)
    
    # Cria o scatter plot
    ggplot(data = data.frame(x, y, grupo), aes(x = x, y = y, color = grupo)) +
      geom_point() +
      scale_color_manual(values = c("A" = "red", "B" = "blue", "C" = "green"))
  })
  
}

# Cria o aplicativo Shiny
shinyApp(ui = ui, server = server)

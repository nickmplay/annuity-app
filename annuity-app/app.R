
library(shiny)

# Define UI for application that draws a plot
ui <- fluidPage(

    # Application title
    titlePanel("Iris petal data"),

    # Sidebar with a slider input for iris species
    sidebarLayout(
        sidebarPanel(
            selectInput("species_selection", "Species", 
                        multiple = T,
                        choices = c("setosa", "versicolor", "virginica"))
        ),

        # Show a plot of the iris species by petal length and width
        mainPanel(
           plotOutput("distPlot")
        )
    )
)

# Define server logic required to draw a plot
server <- function(input, output) {

    output$distPlot <- renderPlot({
      # generate empty plot
      plot(1, type = "n", 
           xlab = "Petal Length", ylab = "Petal Width", 
           xlim = c(0, 7), ylim = c(0, 3))
      
      # define colour mapping
      iris_cols <- c("setosa" = 1, "versicolor" = 2, "virginica" = 3)
      
      # loop selection and add points to plot
      for(i in input$species_selection){
        points(iris[iris$Species == i, "Petal.Length"], 
               iris[iris$Species == i, "Petal.Width"], 
               col = iris_cols[[i]], 
               pch = 16)
      }
      
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

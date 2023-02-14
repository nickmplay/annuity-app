
library(shiny)

# load prepared data
df = read.csv("annuities.csv")
colnames(df)[1] <- gsub('^...','',colnames(df)[1])

# Define UI for application that draws a plot
ui <- fluidPage(

    # Application title
    titlePanel("Reinsurer Comparison"),

    # Sidebar with a slider input for iris species
    sidebarLayout(
        sidebarPanel(
            selectInput("ri_selection", "Reinsurer", 
                        multiple = T,
                        choices = unique(df$Reinsurer))
        ),

        # Show a plot of the iris species by petal length and width
        mainPanel(
           plotOutput("distPlot1"),
           plotOutput("distPlot2")
        )
    )
)

# Define server logic required to draw a plot
server <- function(input, output) {

    output$distPlot1 <- renderPlot({
      # generate empty plot
      plot(1, type = "n", 
           main = "Male annuities",
           xlab = "Age", ylab = "% BEL", 
           xlim = c(50, 80), ylim = c(-0.02, 0.09))
      
      # define colour mapping
      df_cols <- c("R1" = 1, "R2" = 2)
      
      # loop selection and add points to plot
      df_s <- df[df$Sex == "Male", ]
      for(i in input$ri_selection){
        lines(df_s[df_s$Reinsurer == i, "Age"], 
               df_s[df_s$Reinsurer == i, "Value"], 
               col = df_cols[[i]], 
               pch = 16)
      }
    }, height = 450, width = 700)
    
    output$distPlot2 <- renderPlot({
      # generate empty plot
      plot(1, type = "n", 
           main = "Female annuities",
           xlab = "Age", ylab = "% BEL", 
           xlim = c(50, 80), ylim = c(-0.02, 0.09))
      
      # define colour mapping
      df_cols <- c("R1" = 1, "R2" = 2)
      
      # loop selection and add points to plot
      df_s <- df[df$Sex == "Female", ]
      for(i in input$ri_selection){
        lines(df_s[df_s$Reinsurer == i, "Age"], 
               df_s[df_s$Reinsurer == i, "Value"], 
               col = df_cols[[i]], 
               pch = 15)
      }
    }, height = 450, width = 700)
}

# Run the application 
shinyApp(ui = ui, server = server)

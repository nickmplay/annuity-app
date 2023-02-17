

# load dependencies -------------------------------------------------------

library(shiny)
library(shinydashboard)


# define global variables -------------------------------------------------

# global data
df = read.csv("annuities.csv")

# define colour mapping
df_cols <- c("McDonald Re" = "#C77CFF", 
             "RGB" = "#F8766D", 
             "MetDeath" = "#00BFC4")


# Define UI for application that draws a plot -----------------------------

ui <- fluidPage(
  
  # Application title
  titlePanel("Reinsurer Comparison"),
  
  # Sidebar with a slider input for reinsurer
  sidebarLayout(
    sidebarPanel(
      selectInput("deal_selection", "Deal", 
                  choices = unique(df$Deal)),
      
      selectInput("ri_selection", "Reinsurer", 
                  multiple = T,
                  choices =  unique(df$Reinsurer)),
      
      sliderInput(
        "age_selection", label = "Age range",
        min = 50, value = c(50, 90), max = 90
      ), 
      
      # Stylise text output for ri_winner (CSS in tag$style can be adjusted)
      fluidRow(
        textOutput("ri_winner"), 
        tags$head(
          tags$style(
            "#ri_winner{color: black; font-size: 16px; font-style: bold; text-align: center}"
          )
        )
      ),
      
      # debug
      fluidRow(
        column(
          12, 
          verbatimTextOutput("ri_select")
          )
        )
    ),
    
    # Show a side-by-side plot of the annuitants by reinsurer
    mainPanel(
      fluidRow(
        splitLayout(
          cellWidths = c("50%", "50%"),
          plotOutput("distPlot1"),
          plotOutput("distPlot2")
        )
      )
    )
  )
)


# Define server logic required to draw a plot -----------------------------

server <- function(input, output) {
  
  # select reinsurers from selected deal
  output$ri_select <- renderPrint({
    dput(unique(df[df$Deal == input$deal_selection, "Reinsurer"]))
  })
  
  # render male plot
  output$distPlot1 <- renderPlot({
    # generate empty plot
    plot(1, type = "n", 
         main = "Male annuities",
         xlab = "Age", ylab = "% BEL", 
         xlim = c(50, 90), ylim = c(-0.02, 0.09))
    
    
    # loop selection and add points to plot
    age_range <- input$age_selection[1]:input$age_selection[2]
    df_s <- df[df$Sex == "Male" & 
                 df$Deal == input$deal_selection & 
                 df$Age %in% age_range, ]
    for(i in input$ri_selection){
      lines(df_s[df_s$Reinsurer == i, "Age"], 
            df_s[df_s$Reinsurer == i, "Value"], 
            col = df_cols[[i]], lwd = 2,
            pch = 16)
    }
  })
  
  # render female plot
  output$distPlot2 <- renderPlot({
    # generate empty plot
    plot(1, type = "n", 
         main = "Female annuities",
         xlab = "Age", ylab = "% BEL", 
         xlim = c(50, 90), ylim = c(-0.02, 0.09))
    
    
    # loop selection and add points to plot
    age_range <- input$age_selection[1]:input$age_selection[2]
    df_s <- df[df$Sex == "Female" & 
                 df$Deal == input$deal_selection & 
                 df$Age %in% age_range, ]
    for(i in input$ri_selection){
      lines(df_s[df_s$Reinsurer == i, "Age"], 
            df_s[df_s$Reinsurer == i, "Value"], 
            col = df_cols[[i]], lwd = 2,
            pch = 15)
    }
  })
  
  # winner 
  output$ri_winner <- renderText({
    age_range <- input$age_selection[1]:input$age_selection[2]
    ri_rank <- aggregate(Value ~ Reinsurer, 
                         df[df$Deal == input$deal_selection & 
                              df$Age %in% age_range, ], 
                         sum)
    paste("The lead reinsurer is", 
          ri_rank[ri_rank$Value == min(ri_rank$Value), "Reinsurer"])
  })
  
  # debugging
  output$debug <- renderPrint({ input$age_selection })
  
  
}


# Run the application  ----------------------------------------------------

shinyApp(ui = ui, server = server)

#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(DT)
library(shinythemes)

# Define UI for application that draws a histogram
# cette partie concerne de user (frame) 

ui <- fluidPage(
    h1('APPLICATION IRIS'),  
    h2("Auteur : Epainete Mubiala"),
    tags$a("Mon Site Web", href = "https : //www.globuter.com"),
    
    theme = shinytheme('cerulean'),
    sidebarLayout(
      sidebarPanel (
        selectInput('plot_type','choisis le type de graphique',
                    choices = c('Histogram','Scatter Plot')),
        #numericInput('age','quel est votre âge ?', value = 10, min = 1, step = 1)
        selectInput('var','choisis une variable :', choices = names(iris)),
        conditionalPanel(
          condition = "input.plot_type == 'Scatter Plot'",
          selectInput('var2','choisis le second variable :', choices = names(iris))
        )
        
      ),
      mainPanel(
        tabsetPanel(
          #tabPanel('Age', textOutput('age_sortie')),
          tabPanel('Data', DTOutput('data'), downloadButton('save_data', 'Save to CSV')),
          tabPanel('statistiques', verbatimTextOutput('summary')),
          tabPanel('Histogramme', 
                   conditionalPanel(
                     condition = "input.plot_type == 'Histogram'",
                     plotOutput('hist')
                   ),
                   conditionalPanel(
                     condition = "input.plot_type == 'Scatter Plot'",
                     plotOutput('nuage')
                   )
                   )
        )
      )
    )

)

# Define server logic required to draw a histogram
#concerne l'exécution des codes au niveau du serveur (Back end)

server <- function(input, output) {
   
    df <- reactive({
      iris
    })
  
  
  
   output$data <- renderDT(
      {
        ## Iris est un data frame generer dans le R(Langage)
        df()
      }
    )
    #output$age_sortie <- renderText ({
      #paste("vous avez", input$age,"ans")
    #})
   #Resumer statistique 
    output$summary <- renderPrint({
      summary(iris)
    })
    
    #Histogramme
    output$hist <- renderPlot({
      hist(iris[, input$var], main = 'Histogramme', xlab = input$var)
    }) 
    
    #sauvegarder de df aub format csv
    
    output$save_data <- downloadHandler(
      filename <- function(){
        paste("data_", Sys.Date(), ".csv", sep =',' )
      },
      content <- function(file){
        write.csv(df(), file)
      }
    )
    
    
    ##Nuage des points
    
    output$nuage <- renderPlot({
      plot(iris[, input$var], iris[, input$var2],
           xlab = input$var, ylab = input$var2)
    })
}

# Run the application 
shinyApp(ui = ui, server = server)

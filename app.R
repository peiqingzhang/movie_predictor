#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(httr)
library(tidyverse)
library(shiny)

values <- reactiveValues()
values$review_text = ""
values$to_show = ""

values$num_button = 0
values$to_show = ""

             
# Define UI for application that draws a histogram
ui <- fluidPage(
   
  navbarPage(
    theme =  shinythemes::shinytheme("cerulean"),  
    "Movie Review Predictor",
    # Application title

    
    tabPanel(id = "write_review", "Write down your review", 
             textAreaInput("review", "Write your review here", "I love this movie!",
                           rows = 10,
                           width = '800px'),
             actionButton("do", "Predict"),
             
             textOutput("score_written")
    ),

    tabPanel(id = "upload_review", "Upload your review", 
    sidebarLayout(
        sidebarPanel(
            fileInput("file1", "Choose a txt file to upload the review",
                      multiple = FALSE,
                      accept = c(
                                 ".txt")),
            textOutput("score_uploaded")
            

            
        ),

  
        mainPanel(
        
          
          fluidRow(textOutput("review"))
            
            
        )
    )
    )
    
)
)


server <- function(input, output, session) {
    
    output$review <- renderText({
        
        req(input$file1)
        
    tryCatch(
        {
           text <- paste(read_lines(input$file1$datapath, skip = 0, n_max = -1L), collapse = '\n') 
        },
        error = function(e) {
            # return a safeError if a parsing error occurs
            stop(safeError(e))
        }
    )
        return(text)
    })
    
### write in
    
    
    socre_text <-  eventReactive(input$do, {
      
      tryCatch(
        {
          
      if(nchar(input$review) >= 10){
        values$r <- POST("http://13.48.45.7:1080/predict", body = list(review = input$review))
        values$str = content(values$r, "text", encoding = "ISO-8859-1")
        values$to_show_written = str_replace_all(values$str,'[\n|\"|{|}]',"")}
      else{
        values$to_show_written = "Please write a little bit more...."
      }
    },
    error = function(e) {
  # return a safeError if a parsing error occurs
    stop(safeError(e))
    }
    )
    
    return(values$to_show_written)
      
    })
    
    
    output$score_written <- renderText({
      socre_text()
    })
    
   
    
    
###upload  
    output$score_uploaded <- renderText({
      
     req(input$file1)
        
       tryCatch(
           {
               
                values$review_text <- paste(read_lines(input$file1$datapath, skip = 0, n_max = -1L), collapse = ' ')
              
                values$r <- POST("http://13.48.45.7:1080/predict", body = list(review = values$review_text))
                values$str = content(values$r, "text", encoding = "ISO-8859-1")
                values$to_show = str_replace_all(values$str,'[\n|\"|{|}]',"")
                isolate(values$to_show)
            },
            error = function(e) {
                # return a safeError if a parsing error occurs
                stop(safeError(e))
            }
        )
        return(values$to_show)
     })
    
    

  

}

# Run the application 
shinyApp(ui = ui, server = server)

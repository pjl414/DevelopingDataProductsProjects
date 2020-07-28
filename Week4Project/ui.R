#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
library(boot)
library(gridExtra)



########################
# Create Shiny Page ####
########################
# Define UI for application that draws a histogram
shinyUI(fluidPage(
    
# Application title
titlePanel("Success rate for confidence intervals"),
tabsetPanel(type = "tabs", 
  tabPanel("Getting Started", 
   h4("Documentation of the Application"),
   p("We will begin by providing some explanation of the Shiny Application which has been designed to explore the success rates of confidence intervals created by randomly sampling from a population.  After reading the documentation, please click on the 'Shiny Application' tab above to interact with the application."),
   h4("Purpose of the Application"),
   p("I created this visualization to demonstrate how a 'confidence level' for a confidence interval can be viewed as a success rate over many iterations of generating confidence intervals with random samples."),
   img(src = "")
   
   
   
  ), 
  tabPanel("Shiny Application", 
       # Sidebar with a slider for sample size and action button to get a new sample.
       fluidRow( position = 'left',
         # Put slider and button in the sidebar
         column(5,
                plotOutput("sampling",
                           height="450px")
         ),
         column(7,
                plotOutput("conf_int",
                           height="450px"))
       ),
       
       fluidRow(
         column(4,
            actionButton("get_samp", "Get one sample"),
            actionButton("get_50", "Get 50 samples"),
            checkboxInput("show_interval","Show confidence interval",
                          value=F)
         ),
         column(4,
            sliderInput("sample_size","Set the fixed sample size",
                        min=5, max = 100, step=5, value=5),
            actionButton("reset","Reset plot")
         ),
         column(4,
            h3(textOutput("success_rate")))
         
       )         
                
    )
 )
)
)

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
   h2("Author: Phil Lombardo"),
   h4("Date: 7/28/2020"),
   p("We will begin by providing some explanation of the Shiny Application which has been designed to explore the success rates of confidence intervals created by randomly sampling from a population.  After reading the documentation, please click on the 'Shiny Application' tab above to interact with the application."),
   h4("Purpose of the Application:"),
   p("I created this visualization to demonstrate how a 'confidence level' for a confidence interval can be viewed as a success rate over many iterations of generating confidence intervals with random samples. Additionally, it helps reinforce the idea of how a confidence interval is created from (hence depends on) a random sample, and that the goal of a confidence interval is to 'capture' the population mean by overlapping with it."),
   h4("Specifics:"),
   p("The application has two visual panels at the top of the page, and assorted buttons, sliders, and check-boxes at the bottom."),
   img(src = "https://raw.githubusercontent.com/pjl414/DevelopingDataProductsProjects/gh-pages/Week4Project/app1.png",
       height = "300px", width = "450px"),
   tags$ul(
     tags$li("The visual panel on the left is an image of the entire population, with the horizontal green line representing the mean at the population level. The visual panel on the right keeps a record of the confidence intervals we create from the random samples as we run our simluation."),
     tags$li("The 'Get one sample' button will collect a single random sample from the population. It highlights which observations were selected as blue dots in the left panel. On the right panel, a dot is placed at the sample mean value for that sample."),
     tags$li("You can use the 'Show confidence interval' check-box to either hide or show the 95% confidence interval associated with that sample you just collected."),
     tags$li("Using the slider, you can select the size of the random sample you want to use as you collect samples are create confidence intervals from them"),
     tags$li("The 'Get 50 samples' button will collect and record the sample means and confidence intervals for 50 samples at a time, and then update the right visual panel with the results."),
     tags$li("Lastly, the text in the lower right corner, 'Success rate', updates with the percentage of simulated confidence intervals that actually contained the population mean.")
   ),
   h4("Main Idea:"),
   p("As you collect many random samples, you will see the success rate approach 95%, which is the confidence level for the confidence intervals we created in the simulation."),
   h5("Additional Notes"),
   tags$ul(
     tags$li("Confidence intervals that do not contain the population mean are colored red, rather than blue."),
     tags$li("Changing the sample size will automatically reset the plot; however, you can use the 'Reset plot' button at anytime to start again."),
     tags$li("As a visual aid, we use a horizontal, dashed blue line a the height of each sample mean as we collect random samples."),
     tags$li("The confidence intervals are t-intervals with a confidence level of 95%.")
   )
   
   
   
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

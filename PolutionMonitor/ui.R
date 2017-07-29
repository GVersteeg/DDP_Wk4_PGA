#
# This is the user-interface definition of the Shiny web application for the 
# Air Polution Monitor (APM) within The Hague (the Netherlands). 
# This monitor is build for the peer graded assignment of Coursera's
# Developing Data Products Course Assignment.
#

library(shiny)

# Define UI for APM application
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Air Polution Monitor"),
  
  # Sidebar with two inputs (component & date) 
  sidebarLayout(
    sidebarPanel(
       dateInput("date",
                   "Select a date:",
                   min = "2016-03-01",
                   max = "2016-03-31",
                   value = "2016-03-01"),
       radioButtons("comp",
                 "Select a poluttant:",
                 c("NO2" = "NO2",
                 "NO" = "NO",
                 "O3" = "O3",
                 "PM10" = "PM10",
                 "PM25" = "PM25")
    )),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("dayPlot")
    )
  )
))

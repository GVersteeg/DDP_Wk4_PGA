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
            radioButtons("wkday",
                         "Select a weekday:",
                         c("Monday" = "Monday",
                           "Tuesday" = "Tuesday",
                           "Wednesday" = "Wednesday",
                           "Thursday" = "Thursday",
                           "Friday" = "Friday",
                           "Saturday" = "Saturday",
                           "Sunday" = "Sunday")),
            radioButtons("comp",
                         "Select a poluttant:",
                         c("NO2" = "NO2",
                           "NO" = "NO",
                           "O3" = "O3",
                           "PM10" = "PM10",
                           "PM25" = "PM25"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
       plotOutput("dayPlot")
    )
  )
))

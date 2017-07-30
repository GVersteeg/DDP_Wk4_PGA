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
  titlePanel("Air Polution Monitor (APM)"),
  
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
        tabsetPanel(type = "tabs",
             tabPanel("Plot", br(), plotOutput("dayPlot")),
             tabPanel("Help", br(), 
                 h3("How to use APM"),
                 p("The Air Polution Monitor plots the hourly levels
                   of a specific polutant on an average weekday."),
                 p("The hourly levels are an average of the polution levels
                   of measurements taken on three different locations in
                   the Hague (the Netherlands) during the years 2015-2016."),
                 p("You can select the polutant you want to see and the weekday
                   you are interested in. The APM-app will calculate 
                   the polution levels for each hour during the chosen weekday 
                   averaged over the years 2015-2016. It will also show a 
                   smoothed regression line through those points"),
                 p("The APM will enable you to analyze the daily pattern
                   for the chosen polutant and weekday. Be aware of the fact 
                   that some stations do not measure all of the five polutants")
                 )
                   )
              )
  )
))

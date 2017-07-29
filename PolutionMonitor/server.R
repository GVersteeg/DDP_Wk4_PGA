#
# This is the server logic of the Shiny web application for the 
# Air Polution Monitor (APM) within The Hague (the Netherlands). 
# This monitor is build for the peer graded assignment of Coursera's
# Developing Data Products Course Assignment.
#
# We start with the logic that is run only once when the app is uploaded
# to the server-environment. This code block is meant to load libraries
# and data only once.
#
# loading appropr. libraries
library(shiny)
library(dplyr)
library(ggplot2)
library(lubridate)
library(hms)

# setting up the data: an air polution measurements dataset derived
# from the RIVM in the Netherlands. We will use March 2016 as a period during
# which a lot of observations are avaliable from the measurement station at
# the "de Rebecquestraat" in The Hague. One of the observations is the
# "air quality index" (dubbed: aqi), that we will predict using the value of
# the observed polution levels.
df_load <- tbl_df(read.csv2("./data/Export_RS.csv"))
df <- df_load %>%                                 ## Create df
        mutate(comp = as.factor(component)) %>%   ## as factor
        rename(obs = waarde) %>%                  ## rename to english
        rename(aqi = LKI) %>%                     ## rename to english
        mutate(dt = as.POSIXct(strptime(tijdstip,
                "%Y-%m-%d %H"))) %>%        ## add datetime column
        mutate(day = as.POSIXct(strptime(tijdstip,
                "%Y-%m-%d"))) %>%                 ## add date column
        mutate(hrs = as.numeric(format(dt,
                "%H"))) %>%                       ## add hours column
        mutate(ym = as.factor(paste(              ## add yr-mon col.
                format(dt, "%Y"), 
                format(dt, "%m"),
                sep="-"))) %>%    
#        filter(ym == "2016-03") %>%               ## select the period
        select(dt, day, hrs, comp, obs, aqi)    ## relevant cols

# Define server logic required to draw a daily polution levels plot
shinyServer(function(input, output) {
   
  output$dayPlot <- renderPlot({
    
    # process user inputs from ui.R
        dat <- as.POSIXct(strptime(input$date,
                   "%Y-%m-%d")) 
        cmp <- input$comp
#        dfs <- filter(df, comp == cmp & day == dat)
        dfs <- filter(df, comp == cmp)
        fit <- lm(aqi~obs, data=dfs)
        pred = predict(fit)
        dfc <- cbind(dfs, pred) 
        dfg <- gather(dfc, `obs`, `aqi`, `pred`, key="type", value="lvl")
        dfg$type <- as.factor(dfg$type)
        
    # draw the plot with the selected day
    ggplot(dfg, aes(hrs, lvl)) + geom_smooth()
    ggplot(dfg, aes(hrs, lvl)) + geom_point(aes(colour=type))
        
  })
  
})

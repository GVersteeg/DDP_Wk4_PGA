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
df_AVK <- tbl_df(read.csv2("./data/Export_AVK.csv"))
df_BL <- tbl_df(read.csv2("./data/Export_BL.csv"))
df_RS <- tbl_df(read.csv2("./data/Export_RS.csv"))
df_RIVM <- bind_rows(df_AVK, df_BL, df_RS)          ## concatenate stations
df_RIVM$locatie <- sub("Den Haag-","", 
                       df_RIVM$locatie)             ## Skip 'Den Haag-' part

df_prep <-                                          ## Create DF_prep
        df_RIVM %>%                                 ## using DF-RIVM to filter
        rename(ug_m3 = waarde) %>%                  ## rename "waarde"
        mutate(polutant = as.factor(component)) %>% ## rename & set to factor
        mutate(station = as.factor(locatie)) %>%    ## set to format: factor
        mutate(datetime = as.POSIXct(strptime(tijdstip,
                        "%Y-%m-%d %H:%M:%S"))) %>%  ## add datetime column
        mutate(date = as.Date(strptime(tijdstip, 
                        "%Y-%m-%d"))) %>%           ## add date column
        mutate(weekday = format(date, "%A")) %>%    ## add weekday column
        mutate(time = as.hms(datetime)) %>%         ## add time column
        select(date, time, weekday, station,
               polutant, ug_m3)                     ## select relevant cols

# Define server logic required to draw a daily polution levels plot
shinyServer(function(input, output) {
   
    # process user inputs from ui.R
        df_day <- reactive({                                   ## create DF_day
                df_prep %>%                                    ## using DF-prep to
                filter(weekday == input$wkday, polutant == input$comp) %>%
                group_by(time, station) %>%
                summarize(avg = mean(ug_m3, na.rm = TRUE)) %>% ## calc. avg waarde
                arrange(time)                                  ## sort ascending
        })
        
        output$dayPlot <- renderPlot({
                
     # draw the plot with the selected day
        h <- ggplot(df_day(), 
                    aes(x=time, y=avg, colour=station))        ## add graph obj.
        h + geom_point() +
                geom_smooth(span=0.2,se=FALSE) +               ## plot trendline
                scale_x_time(name="Daily hour") +              ## label X-ticks
                ylab("Average polution level (ug/m3)") +       ## label Y-axis
                ggtitle("Polution levels during averaged weekday (the Hague)")
        
  })
})

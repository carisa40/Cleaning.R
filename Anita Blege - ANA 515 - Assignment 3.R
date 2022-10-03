library(ggplot2)
library(dplyr)
library(bslib)
library(tidyverse)
library(knitr)
library(ggcorrplot)
library(hrbrthemes)
library(corrplot)


getwd()
setwd("C:\\Users\\cariz\\Documents\\details_1992")

getwd()
details_1992 <- read.csv('details_1992.csv')

view (details_1992)

nrow(details_1992)

colnames(details_1992)

limit_1992<- details_1992%>%
  
  select (BEGIN_YEARMONTH,BEGIN_DATE_TIME, END_DATE_TIME, BEGIN_DAY, BEGIN_TIME,END_YEARMONTH, END_DAY, END_TIME, EPISODE_ID, EVENT_ID, STATE, STATE_FIPS, MONTH_NAME, CZ_NAME, CZ_TYPE, CZ_FIPS, EVENT_TYPE, SOURCE, BEGIN_LAT, BEGIN_LON, END_LAT, END_LON)

converted_begin_date_time <- as.POSIXct(limit_1992$BEGIN_DATE_TIME, format="%Y-%m-%d %H:%M:%S", tz="UTC")
head(converted_begin_date_time)

converted_end_date_time <- as.POSIXct(limit_1992$END_DATE_TIME, format="%Y-%m-%d %H:%M:%S", tz="UTC")
head(converted_end_date_time)



colnames(limit_1992)

arranged_1992 <- arrange(limit_1992, BEGIN_YEARMONTH)

head(arranged_1992)

title1 <- str_to_title(arranged_1992$STATE)
title2 <- str_to_title(arranged_1992$CZ_NAME)

head(title1)
head(title2)

filtered <- filter(arranged_1992, CZ_TYPE == "C")
head(filtered)

fil_dropped <- select(filtered, -CZ_TYPE)
head(fil_dropped)

str_pad(fil_dropped$STATE_FIPS, width=3, side = "left", pad = "0")
str_pad(fil_dropped$CZ_FIPS, width=3, side = "left", pad = "0")

head(fil_dropped)

united <-  unite(fil_dropped,col='fips'
                 , c('STATE_FIPS', 'CZ_FIPS') , sep = " ", remove = TRUE)
head(united)

padded <- str_pad(united$fips, width=3, side = "left", pad = "0")
head(padded)

to_lower <- rename_all(united, tolower)
head(to_lower)



us_state_info<-data.frame(state=state.name, region=state.region, area=state.area)

head(us_state_info)



events_freq_data <- data.frame(table(united$STATE))
head(events_freq_data)

events_freq_data1 <- rename(events_freq_data, c("state" = "Var1"))
head(events_freq_data1)


upper_us_state_info <- mutate_all(us_state_info, toupper)

head(upper_us_state_info)

merged_data <- merge (x=events_freq_data1, y=upper_us_state_info, by.x="state", by.y = "state")

head(merged_data)

final_plot <- ggplot(merged_data, aes(x=area, y=Freq)) + geom_point(aes(color=region)) + labs(x= "Land Area (Square Miles)", y= "Number of Storm Events in 1992")

final_plot

#screenshot of plot, read me file, markdown file, r script
  
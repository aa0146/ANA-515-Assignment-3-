
library(tidyverse)
library(dplyr)
library(ggplot2)
#1 Reading and saving the data
getwd()

stmevents = read_csv("StormEvents_details-ftp_v1.0_d1993_c20220425.csv")
head(stmevents,5)

#2 Limit the dataframe
vars = c("BEGIN_YEARMONTH","BEGIN_DAY","BEGIN_TIME","BEGIN_DATE_TIME","END_YEARMONTH","END_DAY","END_TIME","END_DATE_TIME",
        "EPISODE_ID","EVENT_ID","STATE","STATE_FIPS","CZ_NAME","CZ_TYPE","CZ_FIPS","EVENT_TYPE","SOURCE","BEGIN_LAT","BEGIN_LON","END_LAT","END_LON")
stmevents = stmevents[vars]
head(stmevents,5)

#3 Order by State names
stmevents = arrange(stmevents,STATE)

#4 Change state and county names to Title Case
stmevents$STATE = str_to_title(stmevents$STATE) 
stmevents$CZ_NAME = str_to_title(stmevents$CZ_NAME) 
head(stmevents)    

#5 
#lIST BY COUNTY FIPS
stmevents = subset(stmevents,CZ_TYPE = "C")

#Remove CZ_TYPE
stmevents = select(stmevents,-CZ_TYPE)

#6
#pad 0 to the variables  
stmevents$STATE_FIPS = str_pad(stmevents$STATE_FIPS,width = 3, side = "left", pad="0")
stmevents$CZ_FIPS = str_pad(stmevents$CZ_FIPS,width = 3, side = "left", pad="0")

#join the 2 variables using unite
stmevents = unite(stmevents,col = "FIPS",c("STATE_FIPS","CZ_FIPS"), sep = '')
head(stmevents$FIPS,5)

#7
#rename all column names to lower case
stmevents = rename_all(stmevents,tolower)

#8 create datafame with state dataframe
us_state_info<-data.frame(state=state.name, region=state.region, area=state.area)

#9 Merge frequency data with state data
freq_state = data.frame(table(stmevents$state))
freq_state = rename(freq_state, c("state"="Var1"))
merged = merge(x=freq_state, y = us_state_info, by.x = "state",b.y = "state") 

#10 Plot
library(ggplot2)
stm_plot = ggplot(merged, aes(x=area,y = Freq)) + geom_point(aes(color= region)) + labs(x="Land area(square miles)",y="# of storm events in 1993")
stm_plot



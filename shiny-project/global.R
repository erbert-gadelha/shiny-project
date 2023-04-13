library(quantmod)
library(shiny)
library(shinydashboard)
library(dplyr)
library(ggplot2)
library(ggthemes)
library(plotly)
library(DT)
library(tidyverse)
library(lubridate)



master_df <- read.csv('date_model_wise_sale.csv')
stock_list <- sort( unique(master_df$Model) )

master_df$X <- NULL

master_df <- master_df %>% drop_na()

Sys.setlocale("LC_ALL","English")
master_df$Date <- as.Date(master_df$Date, format = "%d-%b-%y", pivot.year = 2000)



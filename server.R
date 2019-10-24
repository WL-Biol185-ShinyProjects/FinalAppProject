library(shiny)

#things needed for hurricane animations
require(gganimate)
require(tidyverse)
require(lubridate)
require(ggmap)
require(mapdata)
require(maps)

#importing dataset to work with
atlantic <- read.csv("https://github.com/merhiger20/FinalAppProject/blob/master/atlantic.csv")
pacific <- read.csv("https://github.com/merhiger20/FinalAppProject/blob/master/pacific.csv")


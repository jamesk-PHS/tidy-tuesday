
# 1. Housekeeping and importing data --------------------------------------

library(tidyverse)
library(patchwork)

# Let's load the daat for this week:
tuesdata <- tidytuesdayR::tt_load('2024-12-31')



# We get a large tibble. Let's separate these data into their respective 
# data frames:

book <- tuesdata[[1]]
broadcast_media  <- tuesdata[[2]]
journalism  <- tuesdata[[3]]
leadership  <- tuesdata[[4]]
restaurant_and_chef  <- tuesdata[[5]]
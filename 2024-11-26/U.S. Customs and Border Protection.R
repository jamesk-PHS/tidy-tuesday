
# 1. Housekeeping and importing data --------------------------------------

library(tidyverse)
library(patchwork)

# Let's load the daat for this week:
tuesdata <- tidytuesdayR::tt_load('2024-11-26')

# We get a large tibble. Let's separate these data into their respective 
# data frames:

cbp_resp <- tuesdata[[1]]

cbp_state <- tuesdata[[2]]

# Tidying environment:
rm(tuesdata)

# Let's now get a summary of the data:
summary(cbp_resp)
summary(cbp_state)


# 2. Tidying data ---------------------------------------------------------

# Let's tidy the data to make it nicer to plot:

cbp_resp <- cbp_resp %>% 
  mutate(across(is.character, as.factor))

summary(cbp_resp)



cbp_state <- cbp_state %>% 
  mutate(across(is.character, as.factor))

summary(cbp_state)



# 3. Plotting -------------------------------------------------------------

p1 <- cbp_state %>% 
  group_by(fiscal_year, state) %>% 
  summarise(n = n()) %>% 
  arrange(fiscal_year, desc(n)) %>% 
  ggplot(aes(x = fiscal_year, y = n, colour = state, group = state)) +
  geom_line() +
  labs(title = "Cases")


p2 <- cbp_state %>% 
  group_by(fiscal_year, state) %>% 
  summarise(encounter_count = sum(encounter_count)) %>% 
  arrange(fiscal_year, desc(encounter_count)) %>% 
  ggplot(aes(x = fiscal_year, y = encounter_count, colour = state, group = state)) +
  geom_line() +
  labs(title = "Peopled encountered")

p3 <- cbp_state %>% 
  group_by(fiscal_year, state) %>% 
  summarise(n = n(),
            encounter_count = sum(encounter_count)) %>% 
  mutate(ratio = encounter_count/n) %>% 
  arrange(fiscal_year, desc(ratio)) %>% 
  ggplot(aes(x = fiscal_year, y = ratio, colour = state, group = state)) +
  geom_line() +
  labs(title = "Ratio of cases to people")

p1+p2+p3+plot_layout(guide = "collect")

# Demographics:

cbp_state %>% 
  filter(land_border_region != "Other") %>% 
  group_by(land_border_region, citizenship) %>% 
  summarise(encounter_count = sum(encounter_count)) %>% 
  mutate(prop = encounter_count/sum(encounter_count)) %>% 
  ggplot(aes(x = land_border_region, y = prop, fill = citizenship)) + 
  geom_col() +
  labs(title = "")


cbp_state %>% 
  filter(land_border_region != "Other") %>% 
  group_by(demographic, citizenship) %>% 
  summarise(encounter_count = sum(encounter_count)) %>% 
  mutate(prop = encounter_count/sum(encounter_count)) %>% 
  ggplot(aes(x = demographic, y = prop, fill = citizenship)) + 
  geom_col()


cbp_state %>% 
  filter(land_border_region != "Other") %>% 
  group_by(title_of_authority, citizenship) %>% 
  summarise(encounter_count = sum(encounter_count)) %>% 
  mutate(prop = encounter_count/sum(encounter_count)) %>% 
  ggplot(aes(x = title_of_authority, y = prop, fill = citizenship)) + 
  geom_col()

cbp_state %>% 
  filter(land_border_region != "Other") %>% 
  group_by(title_of_authority, demographic) %>% 
  summarise(encounter_count = sum(encounter_count)) %>% 
  mutate(prop = encounter_count/sum(encounter_count)) %>% 
  ggplot(aes(x = title_of_authority, y = prop, fill = demographic)) + 
  geom_col()



~
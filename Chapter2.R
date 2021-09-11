# Load packages
library(bayesrules)
library(tidyverse)
library(janitor)
library(dplyr)

# Import article data
data(fake_news)

# Tabulate the number of real and fake news
fake_news %>% 
  tabyl(type) %>% 
    adorn_totals("row")
# prior information: incoming articles are likely to be real.

# Tabulate exclamation usage and article type
fake_news %>%
  tabyl(title_has_excl, type) %>%
    adorn_totals("row")
# data: exclamation points are consistent with fake news.


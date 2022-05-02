# 4.1

# Import data
data(bechdel, package = "bayesrules")

# Take a sample of 20 movies
set.seed(84735)
bechdel_20 <- bechdel %>% 
  sample_n(20)

bechdel_20 %>% 
  head(3)


bechdel_20 %>% 
  tabyl(binary) %>% 
  adorn_totals("row")

#4.2

bechdel %>% 
  filter(year == 1991) %>% 
  tabyl(binary) %>% 
  adorn_totals("row")

bechdel %>% 
  filter(year == 2000) %>% 
  tabyl(binary) %>% 
  adorn_totals("row")


bechdel %>% 
  filter(year == 2013) %>% 
  tabyl(binary) %>% 
  adorn_totals("row")


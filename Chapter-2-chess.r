
# 2.2

# get info
?pop_vs_soda

# Load the data
data(pop_vs_soda)

# Summarize pop use by region
pop_vs_soda %>% 
  tabyl(pop, region) %>% 
  adorn_percentages("col")

# 2.3

# Define possible win probabilities
chess <- data.frame(pi= c(0.2, 0.5, 0.8))

# define the prior model
prior <- c(0.1, 0.25, 0.65)

# Simulate 10,000 values of pi from the prior
set.seed(84735)
chess_sim <- sample_n(chess, size=10000, 
                      weight= prior, replace=TRUE)

# simulate 10,000 match outcomes
chess_sim <- chess_sim %>%
  mutate(y= rbinom(10000, size=6, prob=pi))

# Check it out
chess_sim %>%
  head(3)

#Summarize the prior
chess_sim %>% 
  tabyl(pi) %>% 
  adorn_totals("row")

# Plot y by pi
ggplot(chess_sim, aes(x = y)) + 
  stat_count(aes(y = ..prop..)) + 
  facet_wrap(~ pi)
  
# Focus on simulations with y = 1
win_one <- chess_sim %>% 
  filter(y == 1)

# Summarize the posterior approximation
win_one %>% 
  tabyl(pi) %>% 
  adorn_totals("row")

# Plot the posterior approximation
ggplot(win_one, aes(x = pi)) + 
  geom_bar()


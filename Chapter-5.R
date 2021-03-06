library(bayesrules)
library(tidyverse)

plot_beta(alpha = 1, beta = 2)

# Plot the Gamma(10, 2) prior
plot_gamma(shape = 10, rate = 2)

plot_poisson_likelihood(y = c(6, 2, 2, 1), lambda_upper_bound = 10)

plot_gamma_poisson(shape = 10, rate = 2, sum_y = 11, n = 4)

summarize_gamma_poisson(shape = 10, rate = 2, sum_y = 11, n = 4)


#5.3

plot_normal(mean = 6.5, sd = 0.4)

# Load the data
data(football)
concussion_subjects <- football %>%
  filter(group == "fb_concuss")

ggplot(concussion_subjects, aes(x = volume)) + 
  geom_density()

plot_normal_likelihood(y = concussion_subjects$volume, sigma = 0.5)

plot_normal_normal(mean = 6.5, sd = 0.4, sigma = 0.5,
                   y_bar = 5.735, n = 25)


summarize_normal_normal(mean = 6.5, sd = 0.4, sigma = 0.5,
                        y_bar = 5.735, n = 25)



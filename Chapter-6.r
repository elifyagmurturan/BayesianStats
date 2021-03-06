# Load packages
library(tidyverse)
library(janitor)
library(rstan)
library(bayesplot)

# Step 1: Define a grid of 6 pi values
grid_data <- data.frame(pi_grid = seq(from = 0, to = 1, length = 6))

# Step 2: Evaluate the prior & likelihood at each pi
grid_data <- grid_data %>% 
  mutate(prior = dbeta(pi_grid, 2, 2),
         likelihood = dbinom(9, 10, pi_grid))

# Step 3: Approximate the posterior
grid_data <- grid_data %>% 
  mutate(unnormalized = likelihood * prior,
         posterior = unnormalized / sum(unnormalized))

# Confirm that the posterior approximation sums to 1
grid_data %>% 
  summarize(sum(unnormalized), sum(posterior))

# Examine the grid approximated posterior
round(grid_data, 2)

# Set the seed
set.seed(84735)

# Step 4: sample from the discretized posterior
post_sample <- sample_n(grid_data, size = 10000, 
                        weight = posterior, replace = TRUE)

post_sample %>% 
  tabyl(pi_grid) %>% 
  adorn_totals("row")

# Histogram of the grid simulation with posterior pdf
ggplot(post_sample, aes(x = pi_grid)) + 
  geom_histogram(aes(y = ..density..), color = "white") + 
  stat_function(fun = dbeta, args = list(11, 3)) + 
  lims(x = c(0, 1))


# Step 1: Define a grid of 101 pi values
grid_data  <- data.frame(pi_grid = seq(from = 0, to = 1, length = 101))

# Step 2: Evaluate the prior & likelihood at each pi
grid_data <- grid_data %>% 
  mutate(prior = dbeta(pi_grid, 2, 2),
         likelihood = dbinom(9, 10, pi_grid))


# Step 3: Approximate the posterior
grid_data <- grid_data %>% 
  mutate(unnormalized = likelihood * prior,
         posterior = unnormalized / sum(unnormalized))

ggplot(grid_data, aes(x = pi_grid, y = posterior)) + 
  geom_point() + 
  geom_segment(aes(x = pi_grid, xend = pi_grid, y = 0, yend = posterior))

# Set the seed
set.seed(84735)

# Step 4: sample from the discretized posterior
post_sample <- sample_n(grid_data, size = 10000, 
                        weight = posterior, replace = TRUE)

ggplot(post_sample, aes(x = pi_grid)) + 
  geom_histogram(aes(y = ..density..), color = "white", binwidth = 0.05) + 
  stat_function(fun = dbeta, args = list(11, 3)) + 
  lims(x = c(0, 1))

plot_gamma_poisson(s = 3, r = 1, sum_y = 10, n = 2, posterior = FALSE)


# Gamma Poisson Value
# Step 1: Define a grid of 501 lambda values
grid_data   <- data.frame(lambda_grid = seq(from = 0, to = 15, length = 501))

# Step 2: Evaluate the prior & likelihood at each lambda
grid_data <- grid_data %>% 
  mutate(prior = dgamma(lambda_grid, 3, 1),
         likelihood = dpois(2, lambda_grid) * dpois(8, lambda_grid))

# Step 3: Approximate the posterior
grid_data <- grid_data %>% 
  mutate(unnormalized = likelihood * prior,
         posterior = unnormalized / sum(unnormalized))

# Set the seed
set.seed(84735)

# Step 4: sample from the discretized posterior
post_sample <- sample_n(grid_data, size = 10000, 
                        weight = posterior, replace = TRUE)

# Histogram of the grid simulation with posterior pdf 
ggplot(post_sample, aes(x = lambda_grid)) + 
  geom_histogram(aes(y = ..density..), color = "white") + 
  stat_function(fun = dgamma, args = list(13, 3)) + 
  lims(x = c(0, 15))

# STEP 1: DEFINE the model
bb_model <- "
  data {
    int<lower = 0, upper = 10> Y;
  }
  parameters {
    real<lower = 0, upper = 1> pi;
  }
  model {
    Y ~ binomial(10, pi);
    pi ~ beta(2, 2);
  }
"

# STEP 2: SIMULATE the posterior
bb_sim <- stan(model_code = bb_model, data = list(Y = 9), 
               chains = 4, iter = 5000*2, seed = 84735)


as.array(bb_sim, pars = "pi") %>% 
  head(4)

mcmc_trace(bb_sim, pars = "pi", size = 0.1)

# Histogram of the Markov chain values
mcmc_hist(bb_sim, pars = "pi") + 
  yaxis_text(TRUE) + 
  ylab("count")

# Density plot of the Markov chain values
mcmc_dens(bb_sim, pars = "pi") + 
  yaxis_text(TRUE) + 
  ylab("density")

# 6.2.2

# STEP 1: DEFINE the model
gp_model <- "
  data {
    int<lower = 0> Y[2];
  }
  parameters {
    real<lower = 0> lambda;
  }
  model {
    Y ~ poisson(lambda);
    lambda ~ gamma(3, 1);
  }
"

# STEP 2: SIMULATE the posterior
gp_sim <- stan(model_code = gp_model, data = list(Y = c(2,8)), 
               chains = 4, iter = 5000*2, seed = 84735)

# Trace plots of the 4 Markov chains
mcmc_trace(gp_sim, pars = "lambda", size = 0.1)

# Histogram of the Markov chain values
mcmc_hist(gp_sim, pars = "lambda") + 
  yaxis_text(TRUE) + 
  ylab("count")

# Density plot of the Markov chain values
mcmc_dens(gp_sim, pars = "lambda") + 
  yaxis_text(TRUE) + 
  ylab("density")

# STEP 2: SIMULATE the posterior
bb_sim_short <- stan(model_code = bb_model, data = list(Y = 9), 
                     chains = 4, iter = 50*2, seed = 84735)

# Trace plots of short chains
mcmc_trace(bb_sim_short, pars = "pi")

# Density plots of individual short chains
mcmc_dens_overlay(bb_sim_short, pars = "pi")

# Calculate the effective sample size ratio
neff_ratio(bb_sim, pars = c("pi"))

mcmc_trace(bb_sim, pars = "pi")
mcmc_acf(bb_sim, pars = "pi")

# Simulate a thinned MCMC sample
thinned_sim <- stan(model_code = bb_model, data = list(Y = 9), 
                    chains = 4, iter = 5000*2, seed = 84735, thin = 10)

# Check out the results
mcmc_trace(thinned_sim, pars = "pi")
mcmc_acf(thinned_sim, pars = "pi")

rhat(bb_sim, pars = "pi")

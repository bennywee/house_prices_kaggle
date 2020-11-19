// Saturated model (interactive effects + dummies) for predicting housing prices
data {
    int N; // Number of rows
    int N_neighbourhood; // number of neighbourhood categories
    int neighbourhood[N]; // neighbourhood categorical variable
    vector[N] log_sales_price; // log sales price
    vector[N] log_lot_area; // log lot area

    // Test data
    int N_test; // Number of rows
    int neighbourhood_test[N_test]; // neighbourhood categorical variable test data
    vector[N_test] log_lot_area_test; // log lot area test data
    
    // Switch to evaluate likelihood
    int<lower = 0, upper = 1> run_estimation; // Set to zero for prior predictive checks, set to one to evaluate likelihood
    
    //Adjust parameters
    real<lower=0> alpha_sd;
    real<lower=0> beta_sd;
    real<lower=0> bAN_sd;
    real<lower=0> sigma_sd;
}
parameters {
    vector[N_neighbourhood] alpha;
    vector[N_neighbourhood] bAN;
    real bA;
    real<lower=0> sigma;
}
transformed parameters {
    vector[N] gamma;
    vector[N] mu;
  
  for (n in 1:N) {
    gamma[n] = bA + bAN[neighbourhood[n]] * neighbourhood[n];
    mu[n] = alpha[neighbourhood[n]] + gamma[n] * log_lot_area[n];
  }
}
model {
    // Priors
    target += normal_lpdf(alpha | 0, alpha_sd);
    target += normal_lpdf(bA | 0, beta_sd);
    target += normal_lpdf(bAN | 0, bAN_sd);
    target += exponential_lpdf(sigma |1);
    //target += normal_lpdf(sigma |0, sigma_sd);
    
    // Likelihood
    if(run_estimation==1){
        target += normal_lpdf(log_sales_price | mu, sigma);

    }
}
generated quantities {
    vector[N] log_lik;
    vector[N] y_hat;
    vector[N_test] y_test;
    {
    vector[N_test] gamma_test; 
    vector[N_test] mu_test;
    for(n in 1:N){
          log_lik[n] = normal_lpdf(log_sales_price | mu[n], sigma);
          y_hat[n] = normal_rng(mu[n], sigma);      
        }
    for(n in 1:N_test){
          gamma_test[n] = bA + bAN[neighbourhood_test[n]] * neighbourhood_test[n];
          mu_test[n] = alpha[neighbourhood_test[n]] + gamma[n] * log_lot_area_test[n];
          y_test[n] = normal_rng(mu[n], sigma);
        }
    }
}
// Multilevel variable model for predicting housing prices
data {
    int N; // Number of rows
    int N_neighbourhood; // number of neighbourhood categories
    int neighbourhood[N]; // neighbourhood categorical variable
    vector[N] log_sales_price; // log sales price
    vector[N] log_lot_area; // log lot area

    // Test data
    int N_test; // Number of rows in test dataset
    int neighbourhood_test[N_test]; // neighbourhood categorical variable test data
    vector[N_test] log_lot_area_test; // log lot area test data
    
    // Switch to evaluate likelihood
    int<lower = 0, upper = 1> run_estimation; // Set to zero for prior predictive checks, set to one to evaluate likelihood
    
    //Adjust parameters
    real<lower=0> alpha_sd;
    real<lower=0> beta_sd;
    real<lower=0> sigma_sd;
    real<lower=0> sigma_nh_sd;
    real<lower=0> za_nh_sd;
}
parameters {
    real alpha;
    vector[N_neighbourhood] za_nh;
    real beta;
    real<lower=0> sigma;
    real<lower=0> sigma_nh;
}
transformed parameters {
  vector[1] vector_nh[N_neighbourhood];
  for(n in 1:N_neighbourhood) vector_nh[n] = [za_nh[n]]'; // Vector of varying intercepts
}
model {
    vector[N] mu;
    vector[N] alpha_nh;
    
    // Priors
    target += normal_lpdf(alpha | 0, alpha_sd);
    target += normal_lpdf(beta | 0, beta_sd);
    target += normal_lpdf(sigma |0, sigma_sd);
    
    target += normal_lpdf(za_nh | 0, za_nh_sd);
    target += normal_lpdf(sigma_nh | 0 , sigma_nh_sd);

    //linear model
    alpha_nh = alpha + za_nh[neighbourhood] * sigma_nh;
    for(n in 1:N) mu[n] = alpha_nh[n] + beta * log_lot_area[n];
    
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
    vector[N] mu;
    vector[N_test] mu_test;    
    vector[N] alpha_nh;
    vector[N_test] alpha_nh_test;
    
    alpha_nh = alpha + za_nh[neighbourhood] * sigma_nh;
    alpha_nh_test = alpha + za_nh[neighbourhood_test] * sigma_nh;
    
    for(n in 1:N){
            mu[n] = alpha_nh[n] + beta * log_lot_area[n];
            log_lik[n] = normal_lpdf(log_sales_price[n] | mu[n], sigma);
          y_hat[n] = normal_rng(mu[n], sigma);      
        }
    for(n in 1:N_test){
          mu_test[n] = alpha_nh_test[n] + beta * log_lot_area_test[n];
          y_test[n] = normal_rng(mu_test[n], sigma);

        }
    }
}
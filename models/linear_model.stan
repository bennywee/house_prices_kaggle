// Simple linear model for predicting housing prices
data {
    // Fitting the model on training data
    int<lower=0> N; // Number of rows
    vector[N] log_sales_price; // log sales price
    vector[N] log_lot_area; // log lot area

    // Estimating model on test data
    int<lower=0> N_test; // Number of rows
    vector[N_test] log_lot_area_test; // log lot area test data
    
    // Adjust scale parameters in python
    real alpha_sd;
    real beta_sd;
    real sigma_sd;
    
    // Set to zero for prior predictive checks, set to one to evaluate likelihood
    int<lower = 0, upper = 1> run_estimation;
}
parameters {
    real alpha;
    real beta;
    real<lower=0> sigma;
}
model {
    // Priors
    target += normal_lpdf(alpha | 0, alpha_sd);
    target += normal_lpdf(beta | 0, beta_sd);
    //target += normal_lpdf(sigma |0, sigma_sd);
    target += exponential_lpdf(sigma | 1);

    // Likelihood
    if(run_estimation==1){
        target += normal_lpdf(log_sales_price | alpha + beta * log_lot_area, sigma);

    }
}
generated quantities {
    vector[N] log_lik;
    vector[N] y_hat;
    vector[N_test] y_test;
    {
    for(n in 1:N){
          log_lik[n] = normal_lpdf(log_sales_price | alpha + beta * log_lot_area[n], sigma);
          y_hat[n] = normal_rng(alpha + beta * log_lot_area[n], sigma);      
        }
    for(n in 1:N_test){
        y_test[n] = normal_rng(alpha + beta * log_lot_area_test[n], sigma);
        }
    }
}
// No pooling model for predicting housing prices
data {
    // Fitting the model on training data
    int<lower=0> N; // Number of rows
    int<lower=0> neighbourhood[N]; // neighbourhood categorical variable
    int<lower=0> N_neighbourhood; // number of neighbourhood categories
    vector[N] log_sales_price; // log sales price
    vector[N] log_lot_area; // log lot area

    // Adjust scale parameters in python
    real alpha_sd;
    real beta_sd;
    
    // Set to zero for prior predictive checks, set to one to evaluate likelihood
    int<lower = 0, upper = 1> run_estimation;
}
parameters {
    vector[N_neighbourhood] alpha; // Vector of alpha coefficients for each neighbourhood
    real beta;
    real<lower=0> sigma;
}
model {
    // Priors
    target += normal_lpdf(alpha | 0, alpha_sd);
    target += normal_lpdf(beta | 0, beta_sd);
    target += exponential_lpdf(sigma |1);
    
    // Likelihood
    if(run_estimation==1){
        target += normal_lpdf(log_sales_price | alpha[neighbourhood] + beta * log_lot_area, sigma);

    }
}
generated quantities {
    // Uses fitted model to generate values of interest
    vector[N] log_lik; // Log likelihood
    vector[N] y_hat; // Predictions using training data
    {
    for(n in 1:N){
          log_lik[n] = normal_lpdf(log_sales_price | alpha[neighbourhood[n]] + beta * log_lot_area[n], sigma);
          y_hat[n] = normal_rng(alpha[neighbourhood[n]] + beta * log_lot_area[n], sigma);      
        }
    }
}
// No pooling model for predicting housing prices
data {
    // Fitting the model on training data
    int<lower=0> N; // Number of rows
    int<lower=0> neighbourhood[N]; // neighbourhood categorical variable
    int<lower=0> N_neighbourhood; // number of neighbourhood categories
    vector[N] log_sales_price; // log sales price
    vector[N] log_lot_area; // log lot area

    // Estimating model on test data
    int<lower=0> N_test; // Number of rows
    int<lower=0> neighbourhood_test[N_test]; // neighbourhood categorical variable test data
    vector[N_test] log_lot_area_test; // log lot area test data
    
    // Adjust scale parameters in python
    real alpha_sd;
    real beta_sd;
    real sigma_sd;
    
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
    //target += normal_lpdf(sigma |0, sigma_sd);
    target += exponential_lpdf(sigma |1);
    
    
    // Likelihood
    if(run_estimation==1){
        target += normal_lpdf(log_sales_price | alpha[neighbourhood] + beta * log_lot_area, sigma);

    }
}
generated quantities {
    // Uses fitted model to generate values of interest without re running the sampler
    vector[N] log_lik; // Log likelihood
    vector[N] y_hat; // Predictions using training data
    vector[N_test] y_test; // Predictions using test data
    {
    for(n in 1:N){
          log_lik[n] = normal_lpdf(log_sales_price | alpha[neighbourhood[n]] + beta * log_lot_area[n], sigma);
          y_hat[n] = normal_rng(alpha[neighbourhood[n]] + beta * log_lot_area[n], sigma);      
        }
    for(n in 1:N_test){
          y_test[n] = normal_rng(alpha[neighbourhood_test[n]] + beta * log_lot_area_test[n], sigma);
        }
    }
}

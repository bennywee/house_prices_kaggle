// Dummy variable model for predicting housing prices
data {
    int N; // Number of rows
    vector[N] log_sales_price; // log sales price
    vector[N] log_lot_area; // log lot area
    int neighbourhood[N]; // neighbourhood categorical variable
    int N_neighbourhood; // number of neighbourhood categories
    int N_test; // Number of rows
    vector[N_test] log_lot_area_test; // log lot area test data
    int neighbourhood_test[N_test]; // neighbourhood categorical variable test data
    real alpha_sd;
    real beta_sd;
    int<lower = 0, upper = 1> run_estimation; // Set to zero for prior predictive checks, set to one to evaluate likelihood
}
parameters {
    vector[N_neighbourhood] alpha;
    real beta;
    real<lower=0> sigma;
}
model {
    // Priors
    target += normal_lpdf(alpha | 1, alpha_sd);
    target += normal_lpdf(beta | 0, beta_sd);
    target += normal_lpdf(sigma |0, 1);
    
    // Likelihood
    if(run_estimation==1){
        target += normal_lpdf(log_sales_price | alpha[neighbourhood] + beta * log_lot_area, sigma);

    }
}
generated quantities {
    vector[N] log_lik;
    vector[N] y_hat;
    vector[N_test] y_test;
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
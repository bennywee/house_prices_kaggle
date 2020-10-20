// Simple linear model for predicting housing prices
data {
    int N; // Number of rows
    vector[N] log_sales_price; // log sales price
    vector[N] log_lot_area; // log lot area
    real alpha_sd;
    real beta_sd;
    
    // out of sample prediction
    int N_test;
    vector[N_test] log_lot_area_test;
    
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
    target += normal_lpdf(alpha | 1, alpha_sd);
    target += normal_lpdf(beta | 0, beta_sd);
    //target += exponential_lpdf(sigma | 1);
    target += normal_lpdf(sigma |0, 1);
    
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
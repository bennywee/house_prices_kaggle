// Dummy variable model for predicting housing prices
data {
    int N; // Number of rows
    vector[N] log_sales_price; // log sales price
    vector[N] log_lot_area; // log lot area
    real alpha_sd;
    real beta_sd;
    int<lower = 0, upper = 1> run_estimation; // Set to zero for prior predictive checks, set to one to evaluate likelihood
    int N_new;
    vector[N_new] x_new;
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
    vector[N_new] y_new;
    {
    for(n in 1:N){
          log_lik[n] = normal_lpdf(log_sales_price | alpha + beta * log_lot_area[n], sigma);
          y_hat[n] = normal_rng(alpha + beta * log_lot_area[n], sigma);      
        }
    for(n in 1:N_new){
        y_new[n] = normal_rng(alpha + beta * x_new[n], sigma);
        }
    }
}
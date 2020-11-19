// Multilevel variable model for predicting housing prices
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

    // Extra variables
    int P; // vector of covariates
    int P_test; // vector of covariates
    matrix[N, P] X; //covariate matrix
    matrix[N_test, P_test] X_test; //covariate matrix

    // Switch to evaluate likelihood
    int<lower = 0, upper = 1> run_estimation; // Set to zero for prior predictive checks, set to one to evaluate likelihood
    
    //Adjust parameters
    real<lower=0> alpha_sd;
    real<lower=0> beta_sd;
    real<lower=0> sigma_sd;
    real<lower=0> sigma_nh_sd;
    real<lower=0> Rho_eta;
    real<lower=0> beta_vec_sd;
}
parameters {
    real alpha;
    real beta;
    vector[N_neighbourhood] za_nh;
    vector[N_neighbourhood] zb_nh;
    vector[P] beta_vector; // extra variables
    
    real<lower=0> sigma;
    vector<lower=0>[2] sigma_nh;
    corr_matrix[2] Rho;
}
transformed parameters {
  vector[2] vector_nh[N_neighbourhood];
  for(n in 1:N_neighbourhood) vector_nh[n] = [za_nh[n], zb_nh[n]]';
}
model {
    vector[N] mu;
    vector[N] alpha_nh;
    vector[N] beta_nh;
    
    // Priors
    target += normal_lpdf(alpha | 0, alpha_sd);
    target += normal_lpdf(beta | 0, beta_sd);
    target += normal_lpdf(beta_vector | 0, beta_vec_sd);
    target += normal_lpdf(sigma | 0 , sigma_sd);
    target += normal_lpdf(sigma_nh | 0 , sigma_nh_sd);
    target += lkj_corr_lpdf(Rho | Rho_eta);
    
    target += multi_normal_lpdf(vector_nh | rep_vector(0, 2), Rho);
    
    // linear model
    alpha_nh = alpha + za_nh[neighbourhood] * sigma_nh[1];
    beta_nh = beta + zb_nh[neighbourhood] * sigma_nh[2];
    for(n in 1:N) mu[n] = alpha_nh[n] + beta_nh[n] * log_lot_area[n] + X[n,] * beta_vector;

    // Likelihood
    if(run_estimation==1){
        target += normal_lpdf(log_sales_price | mu, sigma);

    }
}
generated quantities {
    vector[N] log_lik;
    vector[N] y_hat;
    vector[N_test] y_test;
    vector[N] alpha_nh;
    vector[N] beta_nh;
    vector[N_test] alpha_nh_test;
    vector[N_test] beta_nh_test;
    {
    vector[N] mu;
    vector[N_test] mu_test;
        
    alpha_nh = alpha + za_nh[neighbourhood] * sigma_nh[1];
    beta_nh = beta + zb_nh[neighbourhood] * sigma_nh[2];
    alpha_nh_test = alpha + za_nh[neighbourhood_test] * sigma_nh[1];
    beta_nh_test = beta + zb_nh[neighbourhood_test] * sigma_nh[2];
    
    for(n in 1:N){
          mu[n] = alpha_nh[n] + beta_nh[n] * log_lot_area[n] + X[n,] * beta_vector;
          log_lik[n] = normal_lpdf(log_sales_price[n] | mu[n], sigma);
          y_hat[n] = normal_rng(mu[n], sigma);      
        }
    for(n in 1:N_test){
          mu_test[n] = alpha_nh_test[n] + beta_nh_test[n] * log_lot_area_test[n] + X_test[n,] * beta_vector;
          y_test[n] = normal_rng(mu_test[n], sigma);
        }
    }
}
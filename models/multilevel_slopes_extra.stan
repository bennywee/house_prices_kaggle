// Multilevel variable model for predicting housing prices
// Extra covariates
data {
    int N; // Number of rows
    int N_test; // Number of rows
    int P; // vector of covariates
    int P_test; // vector of covariates
    matrix[N, P] X; //covariate matrix
    matrix[N_test, P_test] X_test; //covariate matrix
    vector[N] log_sales_price; // log sales price
    int neighbourhood[N]; // neighbourhood categorical variable
    int N_neighbourhood; // number of neighbourhood categories
    int neighbourhood_test[N_test]; // neighbourhood categorical variable test data
    vector[N] log_lot_area; // log lot area
    vector[N_test] log_lot_area_test; // log lot area test data
    int<lower = 0, upper = 1> run_estimation; // Set to zero for prior predictive checks, set to one to evaluate likelihood
}
parameters {
    vector[N_neighbourhood] alpha_j;
    vector[N_neighbourhood] beta_j;
    real alpha;
    real beta;
    vector[P] beta_vector;
    real<lower=0> sigma;
    vector<lower=0>[2] sigma_nh;
    corr_matrix[2] Rho;
}
transformed parameters {
  vector[2] mu_ab = [alpha, beta]'; // Vector of grand means of varying effects
  vector[2] v_a_b_nh[N_neighbourhood]; // Vector of adaptive priors for alpha and beta
  cov_matrix[2] sigma_rho; // Covariance matrix
  for (n in 1:N_neighbourhood) v_a_b_nh[n,1:2] = [alpha_j[n], beta_j[n]]'; // Fill adaptive priors matrix with the adaptive parameters
  sigma_rho = quad_form_diag(Rho,sigma_nh);
}
model {
    vector[N] mu;
    
    // Priors
    target += normal_lpdf(alpha | 1, 0.01);
    target += normal_lpdf(beta | 0, 0.1);
    target += normal_lpdf(beta_vector | 0, 0.1);
    target += normal_lpdf(sigma |0, 1);
    target += normal_lpdf(sigma_nh | 0 , 1);
    target += lkj_corr_lpdf(Rho | 4);
    
    // linear model  
    for(n in 1:N) mu[n] = alpha_j[neighbourhood[n]] + beta_j[neighbourhood[n]] * log_lot_area[n] + X[n,] * beta_vector;

    // Likelihood
    if(run_estimation==1){
        target += normal_lpdf(log_sales_price | mu, sigma);
        target += multi_normal_lpdf(v_a_b_nh |mu_ab , sigma_rho);

    }
}
generated quantities {
    vector[N] log_lik;
    vector[N] y_hat;
    vector[N_test] y_test;
    {
    vector[N] mu;
    vector[N_test] mu_test;
    for(n in 1:N){
          mu[n] = alpha_j[neighbourhood[n]] + beta_j[neighbourhood[n]] * log_lot_area[n]+ X[n,] * beta_vector;
          log_lik[n] = normal_lpdf(log_sales_price[n] | mu[n], sigma);
          y_hat[n] = normal_rng(mu[n], sigma);      
        }
    for(n in 1:N_test){
          mu_test[n] = alpha_j[neighbourhood_test[n]] + beta_j[neighbourhood_test[n]] * log_lot_area_test[n] + X_test[n,] * beta_vector;
          y_test[n] = normal_rng(mu_test[n], sigma);
        }
    }
}
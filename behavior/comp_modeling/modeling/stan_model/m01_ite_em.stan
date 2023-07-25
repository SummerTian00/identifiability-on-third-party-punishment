// The egocentric equality model: this model assumes that participants only cared about inequality between themselves and the other two players.
// The model implemention followed the approach in the HBayesian: Ahn, W. Y., Haines, N., & Zhang, L. (2017). 
// Revealing neurocomputational mechanisms of reinforcement learning and decision-making with the hBayesDM package. Computational Psychiatry, 1, 24.
// hyperpriors were set to normal (0,10) and hallf-cauchy(0,5)

data {//these variable names should be consistent with input data names
  int<lower=1> N; // define sub number
  int<lower=1> T; // define trial number
  int<lower=1, upper=T> Tsubj[N]; //trial number for each sub
  real xd[N, T]; //xd for each subject and trial
  real xv[N, T]; //xv for each subject and trial
  real choice[N, T];//choice,0,2,4,6,as continuous data
  int choice_category[N, T];//choice,1,2,3,4,as category
  int cond[N, T];//condition:1=amb;2=ide.
}

transformed data {
}

parameters {
// Declare all parameters as vectors for vectorizing
  // Hyper(group)-parameters
  vector[2] mu_pr; //mean of the parameters,3 paras
  vector<lower=0>[2] sigma; //variance of the parameters, 3 paras

  // Subject-level raw parameters (for Matt trick)
  vector[N] alpha_pr;  // alpha: averse to disadvantaged inequality
  vector[N] tau_pr;    // tau: Inverse temperature
}

transformed parameters {
  // Transform subject-level raw parameters
  real<lower=0, upper=10> alpha[N];
  real<lower=0, upper=10> tau[N];

  for (i in 1:N) {
    alpha[i]   = Phi_approx(mu_pr[1] + sigma[1] * alpha_pr[i]) * 10;
    tau[i]     = Phi_approx(mu_pr[2] + sigma[2] * tau_pr[i]) * 10;
  }
}

model {
  // Hyperparameters
  mu_pr  ~ normal(0, 10);
  sigma  ~ cauchy(0, 5);

  // individual parameters
  alpha_pr ~ normal(0, 1.0);
  tau_pr   ~ normal(0, 1.0);

  for (i in 1:N) {
    for (t in 1:Tsubj[i]) {
      vector[4] util; // Utility for each option

      // utility
       util[1] = 6-0-alpha[i]*(fabs(xd[i,t]-2*0-(6-0))+fabs(xv[i,t]-(6-0)));
       util[2] = 6-2-alpha[i]*(fabs(xd[i,t]-2*2-(6-2))+fabs(xv[i,t]-(6-2)));
       util[3] = 6-4-alpha[i]*(fabs(xd[i,t]-2*4-(6-4))+fabs(xv[i,t]-(6-4)));
       util[4] = 6-6-alpha[i]*(fabs(xd[i,t]-2*6-(6-6))+fabs(xv[i,t]-(6-6)));
       

      // Sampling statement
      choice_category[i, t] ~ categorical_logit(util*tau[i]);

    } // end of t loop
  } // end of i loop
}

generated quantities {
  // For group level parameters
  real<lower=0, upper=10> mu_alpha;
  real<lower=0, upper=10> mu_tau;
  //real<lower=0, upper=1> mu_ep;
  //real Uc[N, T]; //value of choosen option

  // For log likelihood calculation
  real log_lik[N];

  // For posterior predictive check
 // real y_pred[N, T];

  // Set all posterior predictions to 0 (avoids NULL values)
  // for (i in 1:N) {
  //   for (t in 1:T) {
  //     y_pred[i, t] = -1;
  //   }
  // }

  mu_alpha = Phi_approx(mu_pr[1]) * 10;
  mu_tau   = Phi_approx(mu_pr[2]) * 10;


  { // local section, this saves time and space
    for (i in 1:N) {
      log_lik[i] = 0.0;

      for (t in 1:Tsubj[i]) {
        vector[4] util; // Utility for each option

        // utility
       util[1] = 6-0-alpha[i]*(fabs(xd[i,t]-2*0-(6-0))+fabs(xv[i,t]-(6-0)));
       util[2] = 6-2-alpha[i]*(fabs(xd[i,t]-2*2-(6-2))+fabs(xv[i,t]-(6-2)));
       util[3] = 6-4-alpha[i]*(fabs(xd[i,t]-2*4-(6-4))+fabs(xv[i,t]-(6-4)));
       util[4] = 6-6-alpha[i]*(fabs(xd[i,t]-2*6-(6-6))+fabs(xv[i,t]-(6-6)));
       
       //Uc[i,t] = 6-choice[i, t]-alpha[i]*(fmax(xd[i,t]-2*choice[i, t]-(6-choice[i, t]),0)+fmax(xv[i,t]-(6-choice[i, t]),0))-beta[i]*(fmax((6-choice[i, t])-(xd[i,t]-2*choice[i, t]),0)+fmax((6-choice[i, t])-xv[i,t],0));

        // Calculate log likelihood
         log_lik[i] += categorical_logit_lpmf(choice_category[i,t] | util*tau[i] );
        
        // generate posterior prediction for current trial
        // y_pred[i, t]  = categorical_rng(softmax(util*tau[i]));

      } // end of t loop
    } // end of i loop
  } // end of local section
}
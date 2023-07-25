// The impartial model,multiplicative version: this model assumes that participants act as a judge, while contexts impacts sensitivity to inequality aversion.
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
  vector[3] mu_pr; //mean of the parameters,3 paras
  vector<lower=0>[3] sigma; //variance of the parameters, 3 paras

  // Subject-level raw parameters (for Matt trick)
  vector[N] alpha_a_pr;  // alpha: ambiguous
  vector[N] alpha_i_pr;  // alpha: identified
  vector[N] tau_pr;    // tau: Inverse temperature
}

transformed parameters {
  // Transform subject-level raw parameters
  real<lower=0, upper=10> alpha_a[N];
  real<lower=0, upper=10> alpha_i[N];
  real<lower=0, upper=10> tau[N];

  for (i in 1:N) {
    alpha_a[i] = Phi_approx(mu_pr[1] + sigma[1] * alpha_a_pr[i]) * 10;
    alpha_i[i] = Phi_approx(mu_pr[2] + sigma[2] * alpha_i_pr[i]) * 10;
    tau[i]     = Phi_approx(mu_pr[3] + sigma[3] * tau_pr[i]) * 10;
  }
}

model {
  // Hyperparameters
  mu_pr  ~ normal(0, 10);
  sigma  ~ cauchy(0, 5);

  // individual parameters
  alpha_a_pr ~ normal(0, 1.0);
  alpha_i_pr ~ normal(0, 1.0);
  tau_pr     ~ normal(0, 1.0);

  for (i in 1:N) {

    for (t in 1:Tsubj[i]) {
      vector[4] util; // Utility for each option

      // utility
      if (cond[i, t]==1) { // ambigous cond
          util[1] = 6-0-alpha_a[i]*fabs(xd[i,t]-xv[i,t]-2*0);
          util[2] = 6-2-alpha_a[i]*fabs(xd[i,t]-xv[i,t]-2*2);
          util[3] = 6-4-alpha_a[i]*fabs(xd[i,t]-xv[i,t]-2*4);
          util[4] = 6-6-alpha_a[i]*fabs(xd[i,t]-xv[i,t]-2*6);
      } else { // identified cond
          util[1] = 6-0-alpha_i[i]*fabs(xd[i,t]-xv[i,t]-2*0);
          util[2] = 6-2-alpha_i[i]*fabs(xd[i,t]-xv[i,t]-2*2);
          util[3] = 6-4-alpha_i[i]*fabs(xd[i,t]-xv[i,t]-2*4);
          util[4] = 6-6-alpha_i[i]*fabs(xd[i,t]-xv[i,t]-2*6);
      }

      // Sampling statement
      choice_category[i, t] ~ categorical_logit(util*tau[i]);

    } // end of t loop
  } // end of i loop
}

generated quantities {
  // For group level parameters
  real<lower=0, upper=10> mu_alpha_a;
  real<lower=0, upper=10> mu_alpha_i;
  real<lower=0, upper=10> mu_tau;
  //real Uc[N, T]; //value of choosen option

  // For log likelihood calculation
  real log_lik[N];

  // For posterior predictive check
  //real y_pred[N, T];

  // Set all posterior predictions to 0 (avoids NULL values)
  // for (i in 1:N) {
  //   for (t in 1:T) {
  //     y_pred[i, t] = -1;
  //   }
  // }

  mu_alpha_a = Phi_approx(mu_pr[1]) * 10;
  mu_alpha_i = Phi_approx(mu_pr[2]) * 10;
  mu_tau     = Phi_approx(mu_pr[3]) * 10;


  { // local section, this saves time and space
    for (i in 1:N) {
      log_lik[i] = 0.0;

      for (t in 1:Tsubj[i]) {
        vector[4] util; // Utility for each option

        // utility
      if (cond[i, t]==1) { // ambigous cond
          util[1] = 6-0-alpha_a[i]*fabs(xd[i,t]-xv[i,t]-2*0);
          util[2] = 6-2-alpha_a[i]*fabs(xd[i,t]-xv[i,t]-2*2);
          util[3] = 6-4-alpha_a[i]*fabs(xd[i,t]-xv[i,t]-2*4);
          util[4] = 6-6-alpha_a[i]*fabs(xd[i,t]-xv[i,t]-2*6);
          
          //Uc[i,t] = 6-choice[i, t]-alpha_a[i]*fabs(xd[i,t]-xv[i,t]-2*choice[i, t]);
          
      } else { // identified cond
          util[1] = 6-0-alpha_i[i]*fabs(xd[i,t]-xv[i,t]-2*0);
          util[2] = 6-2-alpha_i[i]*fabs(xd[i,t]-xv[i,t]-2*2);
          util[3] = 6-4-alpha_i[i]*fabs(xd[i,t]-xv[i,t]-2*4);
          util[4] = 6-6-alpha_i[i]*fabs(xd[i,t]-xv[i,t]-2*6);
          
          //Uc[i,t] = 6-choice[i, t]-alpha_i[i]*fabs(xd[i,t]-xv[i,t]-2*choice[i, t]);
      }

        // Calculate log likelihood
         log_lik[i] += categorical_logit_lpmf(choice_category[i,t] | util*tau[i] );
        
        // generate posterior prediction for current trial
         //y_pred[i, t]  = categorical_rng(softmax(util*tau[i]));


      } // end of t loop
    } // end of i loop
  } // end of local section
}
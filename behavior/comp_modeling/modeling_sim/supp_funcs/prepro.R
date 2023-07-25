#1.1. pre-processing function
prepro_func <- function(d_df, general_info) {
  # Currently class(d_df) == "data.table"
  
  # Use general_info of d_df
  subjs   <- general_info$subjs #subj id
  n_subj  <- general_info$n_subj #number of subjs
  t_subjs <- general_info$t_subjs #number of trials for each sub
  t_max   <- general_info$t_max #maxmium number of trials 
  
  # Initialize (model-specific) data arrays
  choice           <- array(-1, c(n_subj, t_max))#choice of participants:0,2,4,6
  choice_category  <- array(-1, c(n_subj, t_max))#choice of participants:1,2,3,4
  xd               <- array(-1, c(n_subj, t_max)) #money dictator allocated to themselves
  xv               <- array(-1, c(n_subj, t_max)) #money dictator allocated to victims
  cond             <- array(-1, c(n_subj, t_max))#conditions:1=amb;2=ide.

  data_new <- data.frame('subid'=rep(-1,n_subj*t_max),'xd'=rep(-1,n_subj*t_max),"xv"=rep(-1,n_subj*t_max),"choice"=rep(-1,n_subj*t_max),
                         "cond"=rep(-1,n_subj*t_max),"choice_category"=rep(-1,n_subj*t_max),"trial"=rep(-1,n_subj*t_max))

  
  # Write from d_df to the data arrays
  for (i in 1:n_subj) {
    subj    <- subjs[i]
    t       <- t_subjs[i]
    DT_subj <- d_df[d_df$subid == subj]
    
    choice[i, 1:t]           <- DT_subj$choice
    choice_category[i, 1:t]  <- DT_subj$choice_category
    xd[i, 1:t]               <- DT_subj$xd
    xv[i, 1:t]               <- DT_subj$xv
    cond[i, 1:t]             <- DT_subj$cond
  }
  
  # Wrap into a list for Stan
  data_list <- list(
    N               = n_subj,
    T               = t_max,
    Tsubj           = t_subjs,
    choice          = choice,
    choice_category = choice_category,
    xd              = xd,
    xv              = xv,
    cond            = cond
  )
  
  # write into a data frame for PPC
  data_new$subid                 <- rep(subjs,each=t_max)
  data_new$trial                 <- rep(rep(1:t_max),times=n_subj)
  data_new$choice                <- as.vector(aperm(choice, c(2,1))) #change the order of arrary and then transfer to a vector
  data_new$choice_category       <- as.vector(aperm(choice_category, c(2,1)))
  data_new$xd                    <- as.vector(aperm(xd, c(2,1)))
  data_new$xv                    <- as.vector(aperm(xv, c(2,1)))
  data_new$cond                  <- as.vector(aperm(cond, c(2,1)))
 
  
  if (general_info$gen_file==1){  #only generate the data file for the main analysis, not for simulation analysis
    write.csv(data_new,file='data_for_cm.csv',row.names = FALSE)
  }
  
  # Returned data_list will directly be passed to Stan
  return(data_list)
}

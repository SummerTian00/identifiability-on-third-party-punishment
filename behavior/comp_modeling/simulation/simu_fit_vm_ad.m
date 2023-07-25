function data = simu_fit_vm_ad(param,design)
%simulate the choice for the third-party punishment,
%  - param: input parameters, alpha, omega_a,omega_i,tau
%  - design, experimental design.
%% parameters
alpha   = param(1); % alpha
omega_a = param(2); %omega_a
omega_i = param(3); %omega_i
tau     = param(4); % temperature

%% design
subs        = design(:,1);
xd          = design(:,2);
xv          = design(:,3);
cond        = design(:,4);
trial       = design(:,5);
choice_real = design(:,6);

%% initialisation
nt=length(design); %trial number
data   = zeros(nt,7); % subjid,xd,xv,choice,cond,choice_category,trial
c=zeros(nt,1)-1;
c_r=zeros(nt,1)-1;

%% generate choices
for t = 1:nt  % trial loop
    % action selection based of softmax transformation
    if cond(t)==1 %amb cond
        U(1)=6-0-alpha*max(xd(t)-xv(t)-omega_a-2*0,0);
        fenzi(1)=exp(tau*U(1));
        U(2)=6-2-alpha*max(xd(t)-xv(t)-omega_a-2*2,0);
        fenzi(2)=exp(tau*U(2));
        U(3)=6-4-alpha*max(xd(t)-xv(t)-omega_a-2*4,0);
        fenzi(3)=exp(tau*U(3));
        U(4)=6-6-alpha*max(xd(t)-xv(t)-omega_a-2*6,0);
        fenzi(4)=exp(tau*U(4));
    else %ide cond
        U(1)=6-0-alpha*max(xd(t)-xv(t)-omega_i-2*0,0);
        fenzi(1)=exp(tau*U(1));
        U(2)=6-2-alpha*max(xd(t)-xv(t)-omega_i-2*2,0);
        fenzi(2)=exp(tau*U(2));
        U(3)=6-4-alpha*max(xd(t)-xv(t)-omega_i-2*4,0);
        fenzi(3)=exp(tau*U(3));
        U(4)=6-6-alpha*max(xd(t)-xv(t)-omega_i-2*6,0);
        fenzi(4)=exp(tau*U(4));
    end
    
    fenmu=fenzi(1)+fenzi(2)+ fenzi(3)+fenzi(4);
    
    for i=1:4
        prob(i)=fenzi(i)/fenmu;
    end
    
    
    % generate choice
    c(t) = find(rand < cumsum(prob(:)),1); % 1,2,3,4
    if c(t)==1
        c_r(t)=0;
    elseif c(t)==2
        c_r(t)=2;
    elseif c(t)==3
        c_r(t)=4;
    elseif c(t)==4
        c_r(t)=6;
    end
    clear prob U fenzi fenmu
end % nt

%% write c and r into output variable 'data'
% subjid,xd,xv,choice,cond,choice_category,trial,choice_real
data(:,1) = subs;
data(:,2) = xd;
data(:,3) = xv;
data(:,4) = c_r;
data(:,5) = cond;
data(:,6) = c;
data(:,7) = trial;
data(:,8) = choice_real;











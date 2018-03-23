function random_selection(r)

%if r=1, reset random seed for completely random simulation
%if r=0  load old random seeds so next simulation should be identical to
%the previous  (for the same initial conditions)
   
   if r==1
    rstate.r=rand('state');
    rstate.rn=randn('state');
    save prev_rand.mat rstate
   else
    load prev_rand
    rand('state',rstate.r);
    randn('state',rstate.rn);
   end
function fp_submit_fc_shuffletest_nsg
%code to submit MIM shuffletest to nsg cluster 

addpath(genpath('./'))
nsub = 26;

for isb = 1:nsub
    fprintf(['starting subject ' num2str(isb) '\n'])
    job{isb} = batch(@fp_fc_shuffletest,0,{isb},'Pool',1);
end

for isb =1:nsub
    fprintf(['waiting for subject ' num2str(isb) '\n'])
    wait(job{isb})
end

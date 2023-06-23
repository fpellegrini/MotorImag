function fp_submit_pac_shuffletest_nsg
%Enable parallel processing of 26 subjects on sng cluster 

isbs = 1:26;

for isb = isbs
    fprintf(['starting sub ' num2str(isb) '\n'])
    job{isb} = batch(@fp_pac_shuffletest,0,{isb},'Pool',1);
end

for isb =isbs
    fprintf(['waiting for sub ' num2str(isb) '\n'])
    wait(job{isb})
end
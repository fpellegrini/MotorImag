%Analysis flow of motor imagery experiment.

%preprocessing 
fp_preprocess

%source projection, aggregation within regions, calculating power and
%testing it statistically 
fp_powertest_MI

%functional connectivity calculation and t-testing between two conditions 
fp_fc_ttest

%functional connectivity shuffling test 
fp_prepare_nsg_submission 
%The following fun is run on the nsg cluster. It calls fp_fc_shuffletest.
fp_submit_fc_shuffletest_nsg 
%Plot shuffletest results 
fp_plot_fc_shuffletest
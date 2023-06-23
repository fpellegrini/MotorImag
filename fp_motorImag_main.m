%Analysis flow of motor imagery experiment.

%preprocessing 
fp_preprocess

%% Analysis of power and linear FC (measured by MIM), as published in Pellegrini 2023 Neuroimage paper 

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

%% Analysis of phase-amplitude coupling between precentral and postcentral cortices using bispectra

%prepare submission of pac shuffling test 
fp_prepare_nsg_submission_pac
%The following fun is run on the nsg cluster. It calls fp_pac_shuffletest.
fp_submit_pac_shuffletest_nsg 
%Plot pac shuffletest results. It calls fp_plot_rdefig
fp_plot_pac_shuffletest
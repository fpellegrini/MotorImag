function fp_prepare_nsg_submission_pac
%Function that preprocesses the data so that it can be uploaded and
%processed on nsg cluster 

DIRIN = '~/Dropbox/Franziska/MotorImag/Data_MI/';

DIROUT = '~/Dropbox/Franziska/MotorImag/Data_MI/PAC/';
if ~exist(DIROUT); mkdir(DIROUT); end 

%subjects with good classification accuracy 
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];

%%
for isb = 1:numel(subs)
    tic
    sub = ['vp' num2str(subs(isb))]
    EEG = pop_loadset('filename',['prep_' sub '.set'],'filepath',DIRIN);
    
    epoch = [1 3]; %select time window between 1 and 3 sec post stimulus 
    
    %align with head model
    eeglabp = fileparts(which('eeglab.m'));
    EEG = pop_dipfit_settings( EEG, 'hdmfile',fullfile(eeglabp, 'plugins','dipfit','standard_BEM','standard_vol.mat'), ...
        'coordformat','MNI','mrifile',fullfile(eeglabp, 'plugins','dipfit','standard_BEM','standard_mri.mat'),...
        'chanfile',fullfile(eeglabp, 'plugins','dipfit','standard_BEM','elec', 'standard_1005.elc'),...
        'coord_transform',[0 0 0 0 0 -1.5708 1 1 1] ,'chansel',[1:EEG.nbchan] );
    
    %compute lead field
    EEG = pop_leadfield(EEG, 'sourcemodel',fullfile(eeglabp,'functions','supportfiles','head_modelColin27_5003_Standard-10-5-Cap339.mat'), ...
        'sourcemodel2mni',[0 -24 -45 0 0 -1.5708 1000 1000 1000] ,'downsample',1);
    
    EEG = eeg_checkset( EEG );
    EEG_left = pop_epoch( EEG, {'1'}, epoch, 'epochinfo', 'yes');
    EEG_right = pop_epoch( EEG, {'2'}, epoch, 'epochinfo', 'yes');

    EEG_left = pop_roi_activity(EEG_left, 'leadfield',EEG_left.dipfit.sourcemodel,'model','LCMV','modelparams',{0.05},'atlas','Desikan-Kilianny','nPCA',1);
    EEG_right = pop_roi_activity(EEG_right, 'leadfield',EEG_right.dipfit.sourcemodel,'model','LCMV','modelparams',{0.05},'atlas','Desikan-Kilianny','nPCA',1);
    
    pop_saveset(EEG_left,'filename',['roi_' sub '_left'],'filepath',DIROUT,'savemode','twofiles')    
    pop_saveset(EEG_right,'filename',['roi_' sub '_right'],'filepath',DIROUT,'savemode','twofiles') 
    
    
    %% Also save relevant data in mat file for easier processing on nsg cluster 
     
    nroi = EEG_left.roi.nROI;
    fs = EEG_left.srate;

    % left    
    data = EEG_left.roi.source_roi_data;
    save([DIROUT sub '_left.mat'],'sub','nroi','data','fs','-v7.3')    
    % right    
    data = EEG_right.roi.source_roi_data;
    save([DIROUT sub '_right.mat'],'sub','nroi','data','fs','-v7.3')
    toc
end
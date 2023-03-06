% cd ~/Dropbox/Franziska/Meditation/matlab/eeglab-develop/
% eeglab

DIRIN = '~/Dropbox/Franziska/MotorImag/Data_MI/';

DIRFIG = '~/Dropbox/Franziska/MotorImag/Figures/Power_MI/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%subjects with good classification accuracy 
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];

%%
isb = 1;
for isub = subs
    
    %load preprocessed EEG
    sub = ['vp' num2str(isub)];
    EEG = pop_loadset('filename',['prep_' sub '.set'],'filepath',DIRIN);
    
    %align with head model
    eeglabp = fileparts(which('eeglab.m'));
    EEG = pop_dipfit_settings( EEG, 'hdmfile',fullfile(eeglabp, 'plugins','dipfit','standard_BEM','standard_vol.mat'), ...
        'coordformat','MNI','mrifile',fullfile(eeglabp, 'plugins','dipfit','standard_BEM','standard_mri.mat'),...
        'chanfile',fullfile(eeglabp, 'plugins','dipfit','standard_BEM','elec', 'standard_1005.elc'),...
        'coord_transform',[0 0 0 0 0 -1.5708 1 1 1] ,'chansel',[1:EEG.nbchan] );
    
    %compute lead field
    EEG = pop_leadfield(EEG, 'sourcemodel',fullfile(eeglabp,'functions','supportfiles','head_modelColin27_5003_Standard-10-5-Cap339.mat'), ...
        'sourcemodel2mni',[0 -24 -45 0 0 -1.5708 1000 1000 1000] ,'downsample',1);
    
    %% epoching
    
    epoch = [1 3]; %from 1 sec after stimulus onset to 3 sec after stimulus onset
    EEG = eeg_checkset( EEG );
    EEG_left = pop_epoch( EEG, {'1'}, epoch, 'epochinfo', 'yes');
    EEG_right = pop_epoch( EEG, {'2'}, epoch, 'epochinfo', 'yes');
    
    EEG_left = pop_roi_activity(EEG_left, 'leadfield',EEG.dipfit.sourcemodel,'model','LCMV','modelparams',{0.05},'atlas','Desikan-Kilianny','nPCA',3);
    EEG_right = pop_roi_activity(EEG_right, 'leadfield',EEG.dipfit.sourcemodel,'model','LCMV','modelparams',{0.05},'atlas','Desikan-Kilianny','nPCA',3);
    
    pop_saveset(EEG_left,'filename',['roi_' sub '_left'],'filepath',DIRIN) 
    pop_saveset(EEG_right,'filename',['roi_' sub '_right'],'filepath',DIRIN) 
    
    %% power 
    
    psl = EEG_left.roi.source_roi_power; %left
    psr = EEG_right.roi.source_roi_power; %right
    
    %normalize power 
    norm_cut = [3 7; 15 40].*2; %because of freq res of 0.5 Hz 
    frq_inds_norm= find(EEG_right.roi.freqs >= norm_cut(1,1) & EEG_right.roi.freqs < norm_cut(1,2));
    frq_inds_norm= [frq_inds_norm; find(EEG_right.roi.freqs >= norm_cut(2,1) & EEG_right.roi.freqs < norm_cut(2,2))];
    psl = psl ./ sum(sum(psl(frq_inds_norm,:)));
    psr = psr ./ sum(sum(psr(frq_inds_norm,:)));
    
    %fband
    clear bands
    bands = [8 13];    
    frq_inds= find(EEG_right.roi.freqs >= bands(1) & EEG_right.roi.freqs < bands(2));
    
    psl = squeeze(mean(psl(frq_inds,:),1));
    psr = squeeze(mean(psr(frq_inds,:),1));
    psd = psl-psr;
    
    save([DIRIN sub '_power.mat'],'psl','psr','psd','-v7.3')
  
    %% collect power of all subjects 
    
    PSL(isb,:) = (psl);
    PSR(isb,:) = (psr);
    isb=isb+1;
    
end

%% Do statistics and plot them 

for iroi=1:EEG_left.roi.nROI
    [h(iroi), p(iroi), ~, stats] = ttest(PSL(:,iroi),PSR(:,iroi),'alpha',0.01);
    t(iroi) = sign(stats.tstat);
end

load cm17;
load('bs_results.mat');
p=-log10(p).* squeeze(t);
allplots_cortex_BS(cortex_highres,p, [-max(abs(p)) max(abs(p))], cm17 ,'-log(p)*sign(t)', 0.3,[DIRFIG 'power_stats'])



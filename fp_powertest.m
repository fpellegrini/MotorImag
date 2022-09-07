% cd ~/Dropbox/Franziska/Meditation/matlab/eeglab-develop/
% eeglab

DIRIN = '~/Dropbox/Franziska/MotorImag/Data_eyes/';

DIRFIG = '~/Dropbox/Franziska/MotorImag/Figures/Power_eyes/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

subs = [2:16 18:26 28:30 33:40];
DB_oc = db_oc;
%

%%

for isub = subs
    
    %% load preprocessed EEG
    sub = ['vp' num2str(isub)];
    EEG = pop_loadset('filename',['prep_' sub '.set'],'filepath',DIRIN);
    
    %Align with head model
    eeglabp = fileparts(which('eeglab.m'));
    EEG = pop_dipfit_settings( EEG, 'hdmfile',fullfile(eeglabp, 'plugins','dipfit','standard_BEM','standard_vol.mat'), ...
        'coordformat','MNI','mrifile',fullfile(eeglabp, 'plugins','dipfit','standard_BEM','standard_mri.mat'),...
        'chanfile',fullfile(eeglabp, 'plugins','dipfit','standard_BEM','elec', 'standard_1005.elc'),...
        'coord_transform',[0 0 0 0 0 -1.5708 1 1 1] ,'chansel',[1:EEG.nbchan] );
    
    %compute lead field
    EEG = pop_leadfield(EEG, 'sourcemodel',fullfile(eeglabp,'functions','supportfiles','head_modelColin27_5003_Standard-10-5-Cap339.mat'), ...
        'sourcemodel2mni',[0 -24 -45 0 0 -1.5708 1000 1000 1000] ,'downsample',1);
    
    %% epoching
    epoch = [2 16];
    EEG = eeg_checkset( EEG );
    EEG_closed = pop_epoch( EEG, {'14'}, epoch, 'epochinfo', 'yes');
    EEG_open = pop_epoch( EEG, {'15'}, epoch, 'epochinfo', 'yes');
    
    nepo = 10;
    if EEG_closed.trials~=nepo || EEG_open.trials~= nepo
        error(['Check trial numbers in subject ' subs{isub}])
    end
    
    EEG_closed = pop_roi_activity(EEG_closed, 'leadfield',EEG.dipfit.sourcemodel,'model','LCMV','modelparams',{0.05},'atlas','Desikan-Kilianny','nPCA',1);
    EEG_open = pop_roi_activity(EEG_open, 'leadfield',EEG.dipfit.sourcemodel,'model','LCMV','modelparams',{0.05},'atlas','Desikan-Kilianny','nPCA',1);
    
    pop_saveset(EEG_closed,'filename',['roi_' sub '_closed'],'filepath',DIRIN) 
    pop_saveset(EEG_open,'filename',['roi_' sub '_open'],'filepath',DIRIN) 
    %% power 
    
    psc = EEG_closed.roi.source_roi_power;
    pso = EEG_open.roi.source_roi_power;
    
    %normalize power 
    norm_cut = [3 7; 15 40].*2;%because of freq res of 0.5 Hz 
    frq_inds_norm= find(EEG_open.roi.freqs >= norm_cut(1,1) & EEG_open.roi.freqs < norm_cut(1,2));
    frq_inds_norm= [frq_inds_norm; find(EEG_open.roi.freqs >= norm_cut(2,1) & EEG_open.roi.freqs < norm_cut(2,2))];
    psc = psc ./ sum(sum(psc(frq_inds_norm,:)));
    pso = pso ./ sum(sum(pso(frq_inds_norm,:)));
    
    %fband
    clear bands
    [~, bands] = fp_matchdbs_eyes(DB_oc,sub);    
    frq_inds= find(EEG_open.roi.freqs >= bands(1) & EEG_open.roi.freqs < bands(2));
    
    psc = squeeze(mean(psc(frq_inds,:),1));
    pso = squeeze(mean(pso(frq_inds,:),1));
    
    psd = psc-pso;
    
    save([DIRIN sub '_power.mat'],'psc','pso','psd','-v7.3')
    
    %% plotting
    
    load cm17;
    D = fp_get_atlas_musdys;
    allplots_cortex_BS(D.cortex_highres,psc, [0 max(psc)], cm17a ,'.', 0.3,[])
    outname = [DIRFIG sub '_closed.png'];
    print(outname,'-dpng');
    close all
    
    allplots_cortex_BS(D.cortex_highres,pso, [0 max(pso)], cm17a ,'.', 0.3,[])
    outname = [DIRFIG sub '_open.png'];
    print(outname,'-dpng');
    close all
    
    allplots_cortex_BS(D.cortex_highres,psd, [ -max(abs(psd)) max(abs(psd))], cm17 ,'.', 0.3,[])
    outname = [DIRFIG sub '_diff.png'];
    print(outname,'-dpng');
    close all
%     
    
%     %% Compute power
%     for it = 1:nepo
%         EEG1 = pop_select(EEG_right,'trial',it);
%         EEG1 = pop_roi_activity(EEG1, 'leadfield',EEG.dipfit.sourcemodel,'model','LCMV','modelparams',{0.05},'atlas','Desikan-Kilianny','nPCA',1);
%         psr(:,:,it) = EEG1.roi.source_roi_power;
%         
%         EEG1 = pop_select(EEG_left,'trial',it);
%         EEG1 = pop_roi_activity(EEG1, 'leadfield',EEG.dipfit.sourcemodel,'model','LCMV','modelparams',{0.05},'atlas','Desikan-Kilianny','nPCA',1);
%         psl(:,:,it) = EEG1.roi.source_roi_power;
%     end
%     
%     %fband
%     bands = {[8 13]};
%     for iba = 1:length(bands)
%         frq_inds{iba} = find(EEG1.roi.freqs >= bands{iba}(1) & EEG1.roi.freqs < bands{iba}(2));
%     end
%     
%     mua_l = log10(squeeze(mean(psl(frq_inds{1},:,:),1)));
%     mua_r = log10(squeeze(mean(psr(frq_inds{1},:,:),1)));
%     
%     for iroi = 1:EEG1.roi.nROI
%         [h_mua(iroi),p_mua(iroi),~,stats] = ttest(squeeze(mua_l(iroi,:)),squeeze(mua_r(iroi,:)));
%         t(iroi) = sign(stats.tstat);
%     end
%     
%     save([DIRIN sub '_power_trials.mat'],'psr','psl','mua_l','mua_r','-v7.3')
%     %%
%     load cm17;
%     
%     D = fp_get_atlas_musdys;
%     
%     p = squeeze(p_mua);
%     %     [p_fdr, ~] = fdr( p, 0.05);
%     %     p(p>p_fdr)=1;
%     p(p>0.05)=1;
%     p=-log10(p).* squeeze(t);
%     if sum(p)~=0
%         allplots_cortex_BS(D.cortex_highres, p, [min(p) max(p)], cm17 ,'.', 0.3,[])
%         outname = [DIRFIG sub '_powerttest_within.png'];
%         print(outname,'-dpng');
%         close all
%     end
%     
    
end
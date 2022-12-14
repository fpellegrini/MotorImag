function fp_fc_test

DIRIN = '~/Dropbox/Franziska/MotorImag/Data_MI/';

DIRFIG = '~/Dropbox/Franziska/MotorImag/Figures/MIM_MI/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
%
% nit=1000;
rng('shuffle')

%%
isb = 1;
for isub = subs
    
    %% load preprocessed EEG
    
    sub = ['vp' num2str(isub)];
    EEG_left = pop_loadset('filename',['roi_' sub '_left.set'],'filepath',DIRIN) ;
    EEG_right = pop_loadset('filename',['roi_' sub '_right.set'],'filepath',DIRIN);
    
    %% MIM scores for left and right
    
    EEG_left = pop_roi_connect(EEG_left, 'methods', {'MIM'});
    EEG_right = pop_roi_connect(EEG_right, 'methods', {'MIM'});
    
    pop_saveset(EEG_left,'filename',['FC_' sub '_left'],'filepath',DIRIN) ;
    pop_saveset(EEG_right,'filename',['FC_' sub '_right'],'filepath',DIRIN);

    %% frequency band of interest 
    
    bands = {[8 13]};    
    for iba = 1:length(bands)
        frq_inds{iba} = find(EEG_left.roi.freqs >= bands{iba}(1) & EEG_left.roi.freqs < bands{iba}(2));
    end
    
    MIMl = squeeze(mean(EEG_left.roi.MIM(frq_inds{1},:,:),1));
    MIMr = squeeze(mean(EEG_right.roi.MIM(frq_inds{1},:,:),1));
    MIMdt = squeeze(MIMl - MIMr);
    save([DIRIN sub '_MIM.mat'],'MIMdt','MIMl','MIMr','-v7.3')


    %% save all subjects in one variable 
    
    MIML(isb,:,:) = MIMl;
    MIMR(isb,:,:) = MIMr;
    isb=isb+1;
end

%% Statistics 

%calculate netMIM 
ml = sum(MIML,3); 
mr = sum(MIMR,3);

%do statistics 
for iroi=1:EEG_left.roi.nROI
    [h(iroi), p(iroi), ~, stats] = ttest(ml(:,iroi),mr(:,iroi),'alpha',0.05);
    t(iroi) = sign(stats.tstat);
end


load cm17;
load(['~/Dropbox/Franziska/Musikerdystonie_Projekt/Daten/processed_bs_wzb/Subject01/bs_results.mat']);
p=-log10(p).* squeeze(t);
allplots_cortex_BS(cortex_highres,p, [-max(abs(p)) max(abs(p))], cm17 ,'-log(p)*sign(t)', 0.3,[DIRFIG 'MIM'])

function fp_prepare_nsg_submission 
%Function that saves relevant data in .mat format

DIRIN = './Data_MI/';

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];

%%
for isb = 1:numel(subs)
    
    %% load preprocessed EEG
    sub = ['vp' num2str(subs(isb))];
    EEG_left = pop_loadset('filename',['roi_' sub '_right.set'],'filepath',DIRIN) ;
    bands = {[8 13]};
    for iba = 1:length(bands)
        frq_inds{iba} = find(EEG_left.roi.freqs >= bands{iba}(1) & EEG_left.roi.freqs < bands{iba}(2));
    end
    nroi = EEG_left.roi.nROI;
    filt1.band_inds = frq_inds{1};
    data = EEG_left.roi.source_roi_data;
    fs = EEG_left.srate;
    
    %% save
    save([DIRIN sub '.mat'],'sub','nroi','filt1','data','fs','-v7.3')

end
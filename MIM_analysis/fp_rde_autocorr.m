function fp_rde_autocorr 
%checks that there is no autocorrelation between trials, so that trial
%shuffling is valid for doing statistics

DIRIN = './';

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
% rois = [50, 46]; %Regions of interest:  precentral r, postcentral r
% rois = [49, 46]; %Regions of interest:  precentral l, postcentral r
rois = [50];

%FOIs
ifl = 5;
ifh = 33;
filt.low = ifl;
filt.high = ifh;

iband1 = 10 +[-2 2];
iband2 = 30 +[-2 2];

nshuf = 1;

%%
tic

%prevent array jobs to start at exactly the same time
for isb = 1:numel(subs)
    %%
    isub = subs(isb)
    
    % load preprocessed EEG
    sub = ['vp' num2str(isub)];
    EEG_left = pop_loadset('filename',['roi1_' sub '_right.set'],'filepath',DIRIN) ;
    fs = EEG_left.srate;
    frqs = sfreqs(fs, fs);
    
    %select data of rois
    d_l = EEG_left.roi.source_roi_data(rois,:,:);
    
    for ishift = 1: size(d_l,3)
        %%
        
        dl1 = d_l;
        if ishift == 1
            dl1(2,:,:) = d_l(1,:,[ishift:end]);
        else
            dl1(2,:,:) = d_l(1,:,[ishift:end 1:ishift-1]);
        end
        
        [cs,coh,~]=data2cs_event(dl1(:,:)',2*fs,2*fs,2*fs,fs);
        csl(ishift,isb) = cs(1,2,20);
        col(ishift,isb) = coh(1,2,20);
        
    end
    t=toc;
    
end

%%

figure; 
figone(40,60)
for isb = 1:numel(subs)-1
    subplot(5,5,isb)
    bar(-log10(squeeze(p(isb,1,:))))
    ylim([0 8])
end
%%
figure
bar(squeeze(mean(r(:,1,:),1)))


%%
figure; 
figone(40,60)
for isb = 1:numel(subs)-1
    subplot(5,5,isb)
    plot(real(csl([40:end 1:39],isb)))
    hold on 
    plot(imag(csl([40:end 1:39],isb)))
    hold on 
    plot(abs(csl([40:end 1:39],isb)))
    legend('real','imag','abs')
    xlim([1 75])
    xticks = 7:10:68;
    xticklabs = -30:10:30;
    set(gca,'XTick',xticks,'XTickLabel',xticklabs)
    grid on 
%     ylim([0 8])
end

%%
figure; 
figone(40,60)
for isb = 1:numel(subs)-1
    subplot(5,5,isb)
    plot(real(col([40:end 1:39],isb)))
    hold on 
    plot(imag(col([40:end 1:39],isb)))
    hold on 
    plot(abs(col([40:end 1:39],isb)))
    legend('real','imag','abs')
    xlim([1 75])
    xticks = 7:10:68;
    xticklabs = -30:10:30;
    set(gca,'XTick',xticks,'XTickLabel',xticklabs)
    grid on 
%     ylim([0 8])
end
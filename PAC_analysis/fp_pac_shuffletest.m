
function fp_pac_shuffletest(isb)

DIRIN = './data/';
DIROUT = './bispecs/';

%subjects with high performance classification
subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
sub = ['vp' num2str(subs(isb))];

rois = [45,46,49,50]; %Regions of interest: postcentral l/r, precentral l/r
nshuf = 5000+1;

%%
tic
% load preprocessed EEG
load([DIRIN sub '_right.mat']);

f_nyq = EEG_left.srate/2; % Nyquist frequency in Hz
dr = 3; %we define PAC only when high freq is at least dr times higher than low freq
f_lm = floor(f_nyq/(dr+1)); %maximum freq for low frequencies in Hz

%select data of rois
d_r = EEG_right.roi.source_roi_data(rois,:,:);

%calculate bispectra
bors = nan(f_lm,f_nyq,4,4,nshuf);
bars = nan(f_lm,f_nyq,4,4,nshuf);

%loop over freq combinations (in Hz)
for ifl = 1:f_lm
    for ifh = ifl*dr:f_nyq
        if (ifh+ifl<f_nyq)
            tic
            filt.low = [ifl];
            filt.high = [ifh]
            
            [bors(ifl,ifh,:,:,:), bars(ifl,ifh,:,:,:)] = fp_pac_bispec_uni(d_r,EEG_left.srate,filt, nshuf);
            toc
        end
    end
end

t=toc;
save([DIROUT sub '_PAC_shuf1-5000.mat'],'bors','bars','t','-v7.3')





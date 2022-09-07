


% cd ~/Dropbox/Franziska/Meditation/matlab/eeglab-develop/
% eeglab

addpath('~/Dropbox/Franziska/Meditation/matlab/eeglab-develop/plugins/roiconnect/libs/brainstorm/');

DIRIN = '~/Dropbox/Franziska/MotorImag/Data/';

DIRFIG = '~/Dropbox/Franziska/MotorImag/Figures/MIM/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

% subs = [2:16 18:26 28:30 33:40];

subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
%

%% load power estimates

isb = 1;
for isub = subs

    sub = ['vp' num2str(isub)];
    load([DIRIN sub '_MIM.mat'])
%     load([DIRIN sub '_aTRGC.mat'])
    
    MIML(isb,:,:) = MIMl;
    MIMR(isb,:,:) = MIMr;
%     MIML(isb,:,:) = aTRGCl; 
%     MIMR(isb,:,:) = aTRGCr; 
    isb=isb+1;
    
end
%%
ml = sum(MIML,3); 
mr = sum(MIMR,3);
nroi = 68;
for iroi=1:nroi
    [h(iroi), p(iroi), ~, stats] = ttest(ml(:,iroi),mr(:,iroi),'alpha',0.05);
    t(iroi) = sign(stats.tstat);
end


load cm17;
D = fp_get_atlas_musdys;


% [p_fdr, ~] = fdr(p, 0.05);
% p(p>0.05)=1;
p=-log10(p).* squeeze(t);
allplots_cortex_BS(D.cortex_highres,p, [-max(abs(p)) max(abs(p))], cm17 ,'.', 0.3,[DIRFIG 'MIM'])
%%
a = mean(ml-mr,1);
allplots_cortex_BS(D.cortex_highres,a, [-max(abs(a)) max(abs(a))], cm17 ,'.', 0.3,[])
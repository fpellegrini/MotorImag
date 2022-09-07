% cd ~/Dropbox/Franziska/Meditation/matlab/eeglab-develop/
% eeglab

addpath('~/Dropbox/Franziska/Meditation/matlab/eeglab-develop/plugins/roiconnect/libs/brainstorm/');

DIRIN = '~/Dropbox/Franziska/MotorImag/Data_MI/';

DIRFIG = '~/Dropbox/Franziska/MotorImag/Figures/Power/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];
%

%% load power estimates

isb = 1;
for isub = subs

    sub = ['vp' num2str(isub)];
    load([DIRIN sub '_power.mat'])
    
%     PSO(isb,:) = (pso); 
%     PSC(isb,:) = (psc); 
    
    PSL(isb,:) = (psl); 
    PSR(isb,:) = (psr); 
    isb=isb+1;
    
end
%%

nroi = 68;
for iroi=1:nroi
%     [h(iroi), p(iroi), ~, stats] = ttest(PSC(:,iroi),PSO(:,iroi),'alpha',0.01);
    [h(iroi), p(iroi), ~, stats] = ttest(PSL(:,iroi),PSR(:,iroi),'alpha',0.01);
    t(iroi) = sign(stats.tstat);
end

load cm17;
D = fp_get_atlas_musdys;


% [p_fdr, ~] = fdr(p, 0.5);
% p(p>p_fdr)=1;
p=-log10(p).* squeeze(t);
allplots_cortex_BS(D.cortex_highres,p, [-max(abs(p)) max(abs(p))], cm17 ,'.', 0.3,[DIRFIG 'power'])






DIRIN = '~/Dropbox/Franziska/MotorImag/Data_eyes/';

DIRFIG = '~/Dropbox/Franziska/MotorImag/Figures/TRGC_eyes_711/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

DIRFIG1 = '~/Dropbox/Franziska/MotorImag/Figures/aTRGC_eyes_711/';
if ~exist(DIRFIG1); mkdir(DIRFIG1); end

DIRFIG2 = '~/Dropbox/Franziska/MotorImag/Figures/posTRGC_eyes_711/';
if ~exist(DIRFIG2); mkdir(DIRFIG2); end

DIRFIG3 = '~/Dropbox/Franziska/MotorImag/Figures/negTRGC_eyes_711/';
if ~exist(DIRFIG3); mkdir(DIRFIG3); end

subs = [2:16 18:26 28:30 33:40];
DB_oc = db_oc;
bands = [7 11];

rng('shuffle')

%%
isb = 1;
for isub = subs
    
    %% load preprocessed EEG
    
    sub = ['vp' num2str(isub)];
    
    EEG_closed = pop_loadset('filename',['FC_' sub '_closed.set'],'filepath',DIRIN) ;
    EEG_open = pop_loadset('filename',['FC_' sub '_open.set'],'filepath',DIRIN) ;    
    
    frq_inds= find(EEG_open.roi.freqs >= bands(1) & EEG_open.roi.freqs < bands(2));
    
    TRGCc = squeeze(mean(EEG_closed.roi.TRGC(frq_inds,:,:),1));
    TRGCo = squeeze(mean(EEG_open.roi.TRGC(frq_inds,:,:),1));
    TRGCdt = squeeze(TRGCc - TRGCo);
    
    aTRGCc = squeeze(mean(abs(EEG_closed.roi.TRGC(frq_inds,:,:)),1));
    aTRGCo = squeeze(mean(abs(EEG_open.roi.TRGC(frq_inds,:,:)),1));
    aTRGCdt = squeeze(aTRGCc - aTRGCo);
    
    uc = squeeze(mean(EEG_closed.roi.TRGC(frq_inds,:,:),1));
    uc(uc<0)=0;
    uo = squeeze(mean(EEG_open.roi.TRGC(frq_inds,:,:),1));
    uo(uo<0)=0; 
    pTRGCc = uc;
    pTRGCo = uo;
    pTRGCdt = squeeze(pTRGCc - pTRGCo);
    
    uc = squeeze(mean(EEG_closed.roi.TRGC(frq_inds,:,:),1));
    uc(uc>0)=0;
    uo = squeeze(mean(EEG_open.roi.TRGC(frq_inds,:,:),1));
    uo(uo>0)=0; 
    nTRGCc = uc;
    nTRGCo = uo;
    nTRGCdt = squeeze(nTRGCc - nTRGCo);
    
%     fp_plot_FC(TRGCc,TRGCo,TRGCdt,DIRFIG,sub)
%     fp_plot_FC(aTRGCc,aTRGCo,aTRGCdt,DIRFIG1,sub)
%     fp_plot_FC(pTRGCc,pTRGCo,pTRGCdt,DIRFIG2,sub)
%     fp_plot_FC(nTRGCc,nTRGCo,nTRGCdt,DIRFIG3,sub)
    
    TRGCC(isb,:,:) = TRGCc; 
    TRGCO(isb,:,:) = TRGCo; 
    aTRGCC(isb,:,:) = aTRGCc; 
    aTRGCO(isb,:,:) = aTRGCo; 
    pTRGCC(isb,:,:) = pTRGCc; 
    pTRGCO(isb,:,:) = pTRGCo; 
    nTRGCC(isb,:,:) = nTRGCc; 
    nTRGCO(isb,:,:) = nTRGCo; 
    
    isb=isb+1;
end



%%
mc = sum(TRGCC,3); 
mo = sum(TRGCO,3);
nroi = 68;
for iroi=1:nroi
    [h(iroi), p(iroi), ~, stats] = ttest(mc(:,iroi),mo(:,iroi),'alpha',0.05);
    t(iroi) = sign(stats.tstat);
end

amc = sum(aTRGCC,3); 
amo = sum(aTRGCO,3);
nroi = 68;
for iroi=1:nroi
    [h(iroi), ap(iroi), ~, stats] = ttest(amc(:,iroi),amo(:,iroi),'alpha',0.05);
    at(iroi) = sign(stats.tstat);
end

load cm17;
D = fp_get_atlas_musdys;
% [p_fdr, ~] = fdr(p, 0.05);
p(p>0.05)=1;
p=-log10(p).* squeeze(t);
allplots_cortex_BS(D.cortex_highres,p, [-max(abs(p)) max(abs(p))], cm17 ,'.', 0.3,[])

% [ap_fdr, ~] = fdr(ap, 0.05);
ap(ap>0.05)=1;
ap=-log10(ap).* squeeze(at);
allplots_cortex_BS(D.cortex_highres,ap, [-max(abs(ap)) max(abs(ap))], cm17 ,'.', 0.3,[])

pmc = sum(pTRGCC,3); 
pmo = sum(pTRGCO,3);
nroi = 68;
for iroi=1:nroi
    [h(iroi), pp(iroi), ~, stats] = ttest(pmc(:,iroi),pmo(:,iroi),'alpha',0.05);
    pt(iroi) = sign(stats.tstat);
end

nmc = sum(nTRGCC,3); 
nmo = sum(nTRGCO,3);
nroi = 68;
for iroi=1:nroi
    [h(iroi), np(iroi), ~, stats] = ttest(nmc(:,iroi),nmo(:,iroi),'alpha',0.05);
    nt(iroi) = sign(stats.tstat);
end

load cm17;
D = fp_get_atlas_musdys;
% [p_fdr, ~] = fdr(p, 0.01);
pp(pp>0.05)=1;
pp=-log10(pp).* squeeze(pt);
allplots_cortex_BS(D.cortex_highres,pp, [-max(abs(pp)) max(abs(pp))], cm17 ,'.', 0.3,[])

% [ap_fdr, ~] = fdr(ap, 0.05);
np(np>0.05)=1;
np=-log10(np).* squeeze(nt);
allplots_cortex_BS(D.cortex_highres,np, [-max(abs(np)) max(abs(np))], cm17 ,'.', 0.3,[])


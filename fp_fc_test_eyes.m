function fp_fc_test_eyes

% fp_addpath_rde

% DIRIN = '/home/bbci/data/haufe/Franziska/data/MIMrealdata/';
DIRIN = '~/Dropbox/Franziska/MotorImag/Data_eyes/';

DIRFIG = '~/Dropbox/Franziska/MotorImag/Figures/TRGC_eyes/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

DIRFIG1 = '~/Dropbox/Franziska/MotorImag/Figures/aTRGC_eyes/';
if ~exist(DIRFIG1); mkdir(DIRFIG1); end

subs = [2:16 18:26 28:30 33:40];
DB_oc = db_oc;

rng('shuffle')

%%
for isub = subs
    
    %% load preprocessed EEG
    
    sub = ['vp' num2str(isub)];
    
    EEG_closed = pop_loadset('filename',['FC_' sub '_closed.set'],'filepath',DIRIN) ;
    EEG_open = pop_loadset('filename',['FC_' sub '_open.set'],'filepath',DIRIN) ;
    
    %% TRGC calculation 
    
    EEG_closed = pop_roi_connect(EEG_closed, 'methods', {'TRGC'});
    EEG_open = pop_roi_connect(EEG_open, 'methods', {'TRGC'});
    
    EEG_closed = vec2mat(EEG_closed); 
    EEG_closed.roi.TRGC = EEG_closed.roi.TRGC_matrix; 
    EEG_open = vec2mat(EEG_open); 
    EEG_open.roi.TRGC = EEG_open.roi.TRGC_matrix; 
    
    pop_saveset(EEG_closed,'filename',['FC_' sub '_closed'],'filepath',DIRIN) ;
    pop_saveset(EEG_open,'filename',['FC_' sub '_open'],'filepath',DIRIN) ;
    
    figure
    subplot(2,1,1)
    plot(EEG_open.roi.freqs,EEG_closed.roi.TRGC(:,:))
    title('closed')
    subplot(2,1,2)
    plot(EEG_open.roi.freqs,EEG_open.roi.TRGC(:,:))
    title('open')
    
    outname = [DIRFIG sub '_butterfly.png'];
    print(outname,'-dpng');
    close all
    
    figure
    subplot(2,1,1)
    plot(EEG_open.roi.freqs,abs(EEG_closed.roi.TRGC(:,:)))
    subplot(2,1,2)
    plot(EEG_open.roi.freqs,abs(EEG_open.roi.TRGC(:,:)))
    
    outname = [DIRFIG1 sub '_butterfly.png'];
    print(outname,'-dpng');
    close all
    
    %fband
    clear bands
    [~, bands] = fp_matchdbs_eyes(DB_oc,sub);    
    frq_inds= find(EEG_open.roi.freqs >= bands(1) & EEG_open.roi.freqs < bands(2));
    
    TRGCc = squeeze(mean(EEG_closed.roi.TRGC(frq_inds,:,:),1));
    TRGCo = squeeze(mean(EEG_open.roi.TRGC(frq_inds,:,:),1));
    TRGCdt = squeeze(TRGCc - TRGCo);
    
    aTRGCc = squeeze(mean(abs(EEG_closed.roi.TRGC(frq_inds,:,:)),1));
    aTRGCo = squeeze(mean(abs(EEG_open.roi.TRGC(frq_inds,:,:)),1));
    aTRGCdt = squeeze(aTRGCc - aTRGCo);
    
    save([DIRIN sub '_TRGC.mat'],'TRGCdt','TRGCc','TRGCo','aTRGCdt','aTRGCc','aTRGCo','-v7.3')
    
    %%
    fp_plot_FC(TRGCc,TRGCo,TRGCdt,DIRFIG,sub)
    fp_plot_FC(aTRGCc,aTRGCo,aTRGCdt,DIRFIG1,sub)
    
%     EEG_closed = pop_roi_connect(EEG_closed, 'methods', {'MIM'});
%     EEG_open = pop_roi_connect(EEG_open, 'methods', {'MIM'});
%     
%     figure
%     subplot(2,1,1)
%     plot(EEG_open.roi.freqs,EEG_closed.roi.MIM)
%     subplot(2,1,2)
%     plot(EEG_open.roi.freqs,EEG_open.roi.MIM)
%     
%     outname = [DIRFIG sub '_butterfly.png'];
%     print(outname,'-dpng');
%     close all
    
%     %fband
%     clear bands
%     [~, bands] = fp_matchdbs_eyes(DB_oc,sub);    
%     frq_inds= find(EEG_open.roi.freqs >= bands(1) & EEG_open.roi.freqs < bands(2));
%     
%     %%
%     MIM_closed = squeeze(mean(EEG_closed.roi.MIM(frq_inds,:),1));
%     MIM_open = squeeze(mean(EEG_open.roi.MIM(frq_inds,:),1));
%     
%     MIMdiff_true = squeeze(MIM_closed - MIM_open);
%     
%     
%     %bring in matrix shape
%     nroi = EEG_closed.roi.nROI;
%     iinds = 0;
%     for iroi = 1:nroi
%         for jroi = iroi+1:nroi
%             iinds = iinds + 1;
%             MIMdt(iroi,jroi) = MIMdiff_true(iinds);
%             MIMdt(jroi, iroi) = MIMdt(iroi, jroi);
%             MIMc(iroi,jroi) = MIM_closed(iinds);
%             MIMc(jroi, iroi) = MIMc(iroi, jroi);
%             MIMo(iroi,jroi) = MIM_open(iinds);
%             MIMo(jroi, iroi) = MIMo(iroi, jroi);
%         end
%     end
%     
%     save([DIRIN sub '_MIM.mat'],'MIMdt','MIMc','MIMo','-v7.3')
%     %%
%     figure
%     figone(15,50)
%     subplot(1,3,1)
%     imagesc(MIMc)
%     title('closed')
%     caxis([0 0.2])
%     colorbar
%     
%     subplot(1,3,2)
%     imagesc(MIMdt)
%     title('diff')
%     caxis([-0.2 0.2])
%     colorbar
%     
%     subplot(1,3,3)
%     imagesc(MIMo)
%     title('open')
%     caxis([0 0.2])
%     colorbar
%     
%     outname = [DIRFIG sub '_matrix.png'];
%     print(outname,'-dpng');
%     close all
%     
%     u = sum(MIMdt,2);
%     load cm17;
%     D = fp_get_atlas_musdys;
%     allplots_cortex_BS(D.cortex_highres,u, [-max(abs(u)) max(abs(u))], cm17 ,'.', 0.3,[])
%     outname = [DIRFIG sub '_diff.png'];
%     print(outname,'-dpng');
%     close all
%     
%     u = sum(MIMc,2);
%     load cm17;
%     D = fp_get_atlas_musdys;
%     allplots_cortex_BS(D.cortex_highres,u, [0 max(abs(u))], cm17 ,'.', 0.3,[])
%     outname = [DIRFIG sub '_closed.png'];
%     print(outname,'-dpng');
%     close all
%     
%     u = sum(MIMo,2);
%     load cm17;
%     D = fp_get_atlas_musdys;
%     allplots_cortex_BS(D.cortex_highres,u, [0 max(abs(u))], cm17 ,'.', 0.3,[])
%     outname = [DIRFIG sub '_open.png'];
%     print(outname,'-dpng');
%     close all
    
    %     %% null distribution
    %
    %     for iit = 1:nit
    %
    %         ind = randperm(nepo,nepo);
    %
    %         EEG1 = pop_select(EEG, 'trial', ind(1:nepo_left));
    %         EEG1 = pop_roi_activity(EEG1,'leadfield',EEG.dipfit.sourcemodel,'model','LCMV','modelparams',{0.05},'atlas','Desikan-Kilianny','nPCA',3);
    %         EEG1 = pop_roi_connect(EEG1, 'methods', {'MIM'});
    %
    %         EEG2 = pop_select(EEG, 'trial',ind(nepo_left+1:nepo));
    %         EEG2 = pop_roi_activity(EEG2, 'leadfield',EEG.dipfit.sourcemodel,'model','LCMV','modelparams',{0.05},'atlas','Desikan-Kilianny','nPCA',3);
    %         EEG2 = pop_roi_connect(EEG2, 'methods', {'MIM'});
    %
    %         MIMdiff(:,iit) = squeeze(mean(EEG1.roi.MIM(frq_inds{1},:),1) - mean(EEG2.roi.MIM(frq_inds{1},:),1));
    %         clear EEG1 EEG2
    %
    %     end
    %
    %
    %     %% Statistics left vs right
    %
    %     %bring in matrix shape
    %     nroi = EEG_left.roi.nROI;
    %     iinds = 0;
    %     for iroi = 1:nroi
    %         for jroi = iroi+1:nroi
    %             iinds = iinds + 1;
    %             MIMd(iroi, jroi,:) = MIMdiff(iinds,:);
    %             MIMd(jroi, iroi,:) = MIMd(iroi, jroi,:);
    %             MIMdt(iroi,jroi) = MIMdiff_true(iinds);
    %             MIMdt(jroi, iroi) = MIMdt(iroi, jroi);
    %         end
    %     end
    %
    %     %sum over one of the region dimensions -> net connectivity
    %     MIMd1 = squeeze(sum(MIMd,1));
    %     MIMdt1 = squeeze(sum(MIMdt,1));
    %
    %     %get pvalue and effect direction
    %     for ii = 1:nroi
    %         a1 = squeeze(sum(MIMd1(ii,:)>MIMdt1(ii))/nit);
    %         a2 = squeeze(sum(MIMd1(ii,:)<MIMdt1(ii))/nit);
    %         [pval(ii),st(ii)] = min([a1,a2]);
    %     end
    %     st(st==2)=-1;
    %
    %     %save this sub
    %     save([DIRIN sub '_FC_perm_' num2str(ep) '.mat'],'pval','st','a1','a2','MIMdiff','MIMdiff_true','-v7.3')
    %
    %     %%
    %     load cm17;
    %     sub = 'BCICIV_calib_ds1g';
    %     D = fp_get_atlas_musdys;
    %
    %     load([sub '_FC_perm_' num2str(0) '.mat'])
    %     p=pval;
    %     [p_fdr, ~] = fdr( pval, 0.05)
    %     p(p>p_fdr)=1;
    %     p(p==0)=0.001;
    %     p=-log10(p).* st;
    %     if sum(p)~=0
    %         allplots_cortex_BS(D.cortex_highres, p, [-max(abs(p)) max(abs(p))], cm17 ,'.', 0.3,[])
    %     end
    %
    %
    %     %% less conservative mc correction
    %
    %     load cm17;
    %     clear p
    %
    %     D = fp_get_atlas_musdys;
    %
    %     for isub = [1 4]
    %
    %         load([subs{isub} '_FC_perm_' num2str(0) '.mat'])
    %
    %         nit = size(MIMdiff,2);
    %
    %         true_max(1) = max(MIMdiff_true);
    %         true_max(2) = max(-MIMdiff_true);
    %
    %         for ii = 1:nit
    %             shuff_max(1,ii)= max(MIMdiff(:,ii));
    %             shuff_max(2,ii)= max(-MIMdiff(:,ii));
    %         end
    %
    %         if any(shuff_max(:)<0)
    %             warning(['Check shuffled values in subject ' subs{isub}])
    %         end
    %
    %         if any (true_max(:)<0)
    %             warning(['Check true values in subject ' subs{isub}])
    %         end
    %
    %         p(isub,1) = sum(true_max(1)<shuff_max(1,:))/nit;
    %         p(isub,2) = sum(true_max(2)<shuff_max(2,:))/nit;
    %
    %         if any(p(isub,:)'<0.05)
    %             iinds = 0;
    %             for iroi = 1:nroi
    %                 for jroi = iroi+1:nroi
    %                     iinds = iinds + 1;
    %                     MIMdt(iroi,jroi) = MIMdiff_true(iinds);
    %                     MIMdt(jroi, iroi) = MIMdt(iroi, jroi);
    %                 end
    %             end
    %
    %             %sum over one of the region dimensions -> net connectivity
    %             MIMdt1 = squeeze(sum(MIMdt,1));
    %             if sum(p(isub,:))~=0
    %                 a = MIMdt1;
    %                 allplots_cortex_BS(D.cortex_highres, a, [-max(abs( a)) max(abs(a))], cm17 ,'.', 0.3,[])
    %             end
    %         end
    %     end
end
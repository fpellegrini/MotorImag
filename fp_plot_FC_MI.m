function fp_plot_FC_MI(FCc,FCo,FCdt,DIRFIG,sub)

load cm17;
D = fp_get_atlas_musdys;

figure
figone(15,50)
subplot(1,3,1)
imagesc(FCc)
title('left')
caxis([0 0.2])
colorbar

subplot(1,3,2)
imagesc(FCdt)
title('diff')
caxis([-0.2 0.2])
colorbar

subplot(1,3,3)
imagesc(FCo)
title('right')
caxis([0 0.2])
colorbar

outname = [DIRFIG sub '_matrix.png'];
print(outname,'-dpng');
close all

u = sum(FCdt,2);
allplots_cortex_BS(D.cortex_highres,u, [-max(abs(u)) max(abs(u))], cm17 ,'.', 0.3,[])
outname = [DIRFIG sub '_diff.png'];
print(outname,'-dpng');
close all

u = sum(FCc,2);
allplots_cortex_BS(D.cortex_highres,u, [-max(abs(u)) max(abs(u))], cm17 ,'.', 0.3,[])
outname = [DIRFIG sub '_left.png'];
print(outname,'-dpng');
close all

u = sum(FCo,2);
allplots_cortex_BS(D.cortex_highres,u, [-max(abs(u)) max(abs(u))], cm17 ,'.', 0.3,[])
outname = [DIRFIG sub '_right.png'];
print(outname,'-dpng');
close all

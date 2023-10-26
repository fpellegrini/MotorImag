function fp_plot_rdefig(data,ca,mask)
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

regions = {'Postcentral left','Postcentral right','Precentral left','Precentral right'};
fig = figure;
figone(20,58)
[ha, ~] = tight_subplot(4,4,[.02 .015],[.1 .03],[.05 .01]);
cl=slanCM('Blues');

%%
u= 1;
u1=0;
for iroi = 1:4
    for jroi = 1:4
        img_data=squeeze(data(:,:,iroi,jroi));
        axes(ha(u));
        
        if numel(unique(img_data(~isnan(img_data))))>1           
            h = imagesc(img_data);
            set(h, 'AlphaData', mask(:,:,iroi,jroi)-isnan(img_data))
            title([regions{jroi} ' - ' regions{iroi}],'FontSize',23)
            grid on
            ha(u).GridAlpha = 0.6;
            if u == 1
                u1 = 1;
            end
        end
        
        caxis(ca)
        colormap(cl)
        axis equal
        
        ylim([0 12])
        xlim([0 50])
        if (u1 == 1 && u<13) || (u1 == 0 && (u<12 || u==16))
            ha(u).XAxis.TickLength = [0 0];
            ha(u).XAxis.TickLabels = [];
        else
            ha(u).XAxis.FontSize=15;
            ha(u).XAxis.TickValues = [0 5 10 15 20 25 30 35 40 45 50];
        end
        
        if (u1 == 1 && rem(u-1,4)==0)|| (u1 == 0 && ((rem(u-1,4)==0 && u~=1) || u==2 ))
            ha(u).YAxis.FontSize=15;
        else
            ha(u).YAxis.TickLength = [0 0];
            ha(u).YAxis.TickLabels = [];
        end
        
        ha(u).Box = 'off';
        
        
        u=u+1;
    end
end
%%
han=axes(fig,'visible','off');
han.XLabel.Visible='on';
han.YLabel.Visible='on';
ylabel_h = ylabel(han,'Phase frequency (Hz)','FontSize',23);
xlabel_h = xlabel(han,'Amplitude frequency (Hz)','FontSize',23);

ylabel_h.Position(1) = -0.13; % change horizontal position of ylabel
xlabel_h.Position(2) = -0.05; % change vertical position of xlabel


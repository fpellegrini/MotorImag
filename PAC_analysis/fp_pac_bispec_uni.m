function [b_orig, b_anti] = fp_pac_bispec_uni(data,fs,filt, nshuf)
%Calculates uncorrected and antisymmetrized bispectra and their null
%distributions using a shuffling approach. First shuffle contains true
%values. 
% Copyright (c) 2023 Franziska Pellegrini and Stefan Haufe

nroi = size(data,1);%number of regions 
segleng = 2*fs; %2 sec
segshift = 2*fs; %2 sec 
epleng = segleng; %2 sec

fres=fs;
frqs = sfreqs(fres, fs);
freqinds = [find(frqs==mean(filt.low)) find(frqs==mean(filt.high))];

%loop over all region combinations 
for iroi = 1:nroi
    for jroi = iroi:nroi
        
        X = data([iroi jroi],:,:); 
        [bs,~] = fp_data2bs_event_uni(X(:,:)', segleng, segshift, epleng, freqinds,nshuf);
        xx = bs - permute(bs, [2 1 3 4 5]); % Anti-symmetrization: Bkmm - Bmkm
        
        %upper freqs (low, left side lobe, high)
        biv_orig_up = squeeze(([abs(bs(1, 2, 2, 2,:)) abs(bs(2, 1, 1, 2,:))]));
        biv_anti_up = squeeze(([abs(xx(1, 2, 2, 2,:)) abs(xx(2, 1, 1, 2,:))]));
        
        %lower freqs (low, high, right side lobe)
        biv_orig_low = squeeze(([abs(bs(1, 2, 2, 1,:)) abs(bs(2, 1, 1, 1,:))]));
        biv_anti_low = squeeze(([abs(xx(1, 2, 2, 1,:)) abs(xx(2, 1, 1, 1,:))]));
          
        %mean across the two possible bispec combinations
        %shape: amplitude ROI x phase ROI x nshuf
        b_orig(jroi,iroi,:) = mean([biv_orig_up(1,:)' biv_orig_low(1,:)'],2);  
        b_orig(iroi,jroi,:) = mean([biv_orig_up(2,:)' biv_orig_low(2,:)'],2);
        b_anti(jroi,iroi,:) = mean([biv_anti_up(1,:)' biv_anti_low(1,:)'],2);  
        b_anti(iroi,jroi,:) = mean([biv_anti_up(2,:)' biv_anti_low(2,:)'],2);  
    end
end
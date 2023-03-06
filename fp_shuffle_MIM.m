function MIM_s = fp_shuffle_MIM(data,npcs,fres,filt1, nshuf)
%data is chan x l_epo x trials 
% Copyright (c) 2022 Franziska Pellegrini and Stefan Haufe

[nchan,l_epo,nepo]= size(data);

[inds, PCA_inds] = fp_npcs2inds(npcs);
ninds = length(inds);
   
for ishuf = 1:nshuf %one iteration takes ~90 sec on my local laptop
    
%     ishuf
    
    %shuffle trials
    if ishuf == 1
        shuf_inds = 1:nepo; 
    else
        shuf_inds = randperm(nepo);   
    end
    
    clear MIM2 CS COH2
    CS = fp_tsdata_to_cpsd(data, fres, 'WELCH', 1:nchan, 1:nchan,1:nepo,shuf_inds);
    
    for ifreq = 1:size(CS,3)
        clear pow
        pow = real(diag(CS(:,:,ifreq)));
        COH2(:,:,ifreq) = CS(:,:,ifreq)./ sqrt(pow*pow');
    end
    
    % loop over sender/receiver combinations to compute time-reversed GC
    for iind = 1:ninds
        if ~isequal(inds{iind}{1}, inds{iind}{2})
            %ind configuration
            subset = [inds{iind}{1} inds{iind}{2}];
            subinds = {1:length(inds{iind}{1}), length(inds{iind}{1}) + (1:length(inds{iind}{2}))};
            
            %MIC and MIM
            [~ , MIM2(:, iind)] =  roi_mim2(COH2(subset, subset, :), subinds{1}, subinds{2});
        end
    end        
      
    % extract measures out of the conn struct
    clear conn
    conn.MIM = MIM2;
    conn.inds = inds;  
    nroi = nchan/npcs(1);
    [MIM_s(:,:,ishuf), ~, ~, ~, ~, ~] = fp_unwrap_conn(conn,nroi,filt1,PCA_inds);

end

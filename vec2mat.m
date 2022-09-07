function EEG = vec2mat(EEG)

nroi = EEG.roi.nROI;
iinds = 0;
for iroi = 1:nroi
    for jroi = (iroi+1):nroi
        iinds = iinds + 1;
        if isfield(EEG.roi,'MIM')
            mim_(:,iroi, jroi) = EEG.roi.MIM(:, iinds,:);
            mim_(:,jroi,iroi) = mim_(:,iroi,jroi);
        end
        if isfield(EEG.roi,'TRGC')
            trgc_(:,iroi,jroi) = EEG.roi.TRGC(:,iinds,1) - EEG.roi.TRGC(:,iinds,2);
            trgc_(:,jroi,iroi) = -trgc_(:,iroi,jroi);
        end
    end
end

if isfield(EEG.roi,'MIM')
    EEG.roi.MIM_matrix = mim_;
end
if isfield(EEG.roi,'TRGC')
    EEG.roi.TRGC_matrix = trgc_;
end
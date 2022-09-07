function [chans, band] = fp_matchdbs_eyes(DB_oc,subID)

for iEntry = 1:numel(DB_oc) 
    names{iEntry} = DB_oc{iEntry}{1};
end

iMatch = find(strcmp(subID,names));

if ~isempty(iMatch)
    chans = DB_oc{iMatch}{2};
    band = DB_oc{iMatch}{3};
else 
    chans =[];
    band = [];
end



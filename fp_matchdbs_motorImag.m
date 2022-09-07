function chans = fp_matchdbs_motorImag(DB_noisechans,subID)

for iEntry = 1:numel(DB_noisechans) 
    names{iEntry} = DB_noisechans{iEntry}{1};
    chanID{iEntry} = DB_noisechans{iEntry}{2};
end

iMatch = find(strcmp(subID,names));

if ~isempty(iMatch)
    chans = DB_noisechans{iMatch}{2};
else 
    chans =[];
end

end

% cd ~/Dropbox/Franziska/Meditation/matlab/eeglab-develop/
% eeglab

addpath('~/Dropbox/Franziska/Meditation/matlab/eeglab-develop/plugins/dipfit/standard_BEM/elec/');
addpath('~/Dropbox/Franziska/Meditation/matlab/eeglab-develop/plugins/roiconnect/libs/brainstorm/');

DIRIN = '/Users/franziskapellegrini/Dropbox/VitalBCI/mat/rest/';

DIROUT = '~/Dropbox/Franziska/MotorImag/Data_eyes/';
if ~exist(DIROUT); mkdir(DIROUT); end

DIRFIG = '~/Dropbox/Franziska/MotorImag/Figures/Sensordata_eyes/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

dsRatio = 10;
nsub = 40 ;

% DB_oc = db_oc;
%%
for isub = [2:16 18:26 28:nsub] %subject 1, 17 and 27 not available
    
    clearvars -except DIRIN DIROUT DIRFIG dsRatio nsub DB_oc isub 
    sub = ['vp' num2str(isub)];
    
    load([DIRIN sub '.mat'])
    
    %convert to microV
    eegdata = 0.1 * double(cnt.x)';
    
    %filter before resampling
    fs = 1000;
    notchb = [48 52];
    [bband, aband] = butter(2, notchb/fs*2,'stop');
    [bhigh, ahigh] = butter(2, 1/fs*2, 'high');
    [blow, alow] = butter(2, 45/fs*2, 'low');
    
    eegdata = filtfilt(bhigh, ahigh, eegdata');
    eegdata = filtfilt(bband, aband, eegdata);
    eegdata = filtfilt(blow, alow, eegdata)';
    
    %resample
    eegdata = eegdata(:,1:dsRatio:end);
    fs = 100;
    
    %also enter marker positions
    if ~(strcmp(mrk.className{1},'eyes_closed')) || ~(strcmp(mrk.className{2},'eyes_open'))
        error(['check classNames in subject ' subs{isub}])
    end
    eegdata(end+1,:) = zeros(1,size(eegdata,2));
    eegdata(end,mrk.pos) = mrk.toe;
    
    %load data into EEG struct
    EEG.etc.eeglabvers = '2021.1'; % this tracks which version of EEGLAB is being used, you may ignore it
    EEG = pop_importdata('dataformat','array','nbchan',0,'data','eegdata','setname','test','srate',100,'pnts',0,'xmin',0);
    EEG = eeg_checkset( EEG );
    
    %add events
    EEG = pop_chanevent( EEG, EEG.nbchan,'edge','leading');
    
    %% add chan info
    
    %load template
    eloc = readlocs('standard_1005.elc' );
    
    %remove all channels of eloc that are not contained in data
    out = [];
    out_eloc=[];
    in = [];
    for ii = 1:length(eloc)
        if ~ismember(eloc(ii).labels,cnt.clab)
            out = [out,ii];
        else
            in = [in find(strcmp(eloc(ii).labels,cnt.clab))];
        end
    end
    eloc(out)=[];
    
    %remove channels in data that have not been found in eloc template
    out_labs = setdiff(1:EEG.nbchan,in);
    EEG = pop_select(EEG, 'nochannel',out_labs);
    
    %bring channels in right order
    eloc1 = eloc;     
    for ii = 1:length(eloc)
        name_eloc = eloc(ii).labels;
        ind_clab = find(strcmp(eloc(ii).labels,cnt.clab));
        eloc1(ind_clab) = eloc(ii);   
    end
    
    %add chanlocs to EEG structure
    EEG = pop_editset(EEG,'chanlocs',eloc1,'setname','setName');
    EEG = eeg_checkset(EEG);
    
    %% Preprocessing
    
    eeglabp = fileparts(which('eeglab.m'));
    EEG = pop_chanedit(EEG, 'lookup',fullfile(eeglabp, 'plugins','dipfit','standard_BEM','elec','standard_1005.elc'));
    chanlocs = EEG(1).chanlocs;
    
%     clear chans
%     [chans, band] = fp_matchdbs_eyes(DB_oc,sub);
%     if ~isempty(chans)
%         EEG = pop_select(EEG,'nochannel',chans);
%         EEG = pop_interp(EEG, chanlocs);
%     end

    pop_spectopo(EEG, 1, [],'EEG' , 'percent', 100, 'freq', 10, 'freqrange',[0 50],'electrodes','on');
    outname = [DIRFIG sub '.png'];
    print(outname,'-dpng');
    close all
    
    %% save preprocessed EEG struct
    pop_saveset(EEG,'filename',['prep_' sub],'filepath',DIROUT)      
    
    %%
    epoch = [2 16];
    EEG = eeg_checkset( EEG );
    EEG_closed = pop_epoch( EEG, {'14'}, epoch, 'epochinfo', 'yes');
    EEG_open = pop_epoch( EEG, {'15'}, epoch, 'epochinfo', 'yes');
    
    pop_spectopo(EEG_closed, 1, [],'EEG' , 'percent', 100, 'freq', 10, 'freqrange',[0 50],'electrodes','on');
    outname = [DIRFIG sub '_closed.png'];
    print(outname,'-dpng');
    close all
    
    pop_spectopo(EEG_open, 1, [],'EEG' , 'percent', 100, 'freq', 10, 'freqrange',[0 50],'electrodes','on');
    outname = [DIRFIG sub '_open.png'];
    print(outname,'-dpng');
    close all
end
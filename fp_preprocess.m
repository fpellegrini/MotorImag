cd ~/Dropbox/Franziska/Meditation/matlab/eeglab-develop/
eeglab

addpath('~/Dropbox/Franziska/Meditation/matlab/eeglab-develop/plugins/dipfit/standard_BEM/elec/');
addpath('~/Dropbox/Franziska/Meditation/matlab/eeglab-develop/plugins/roiconnect/libs/brainstorm/');

DIRIN = '/Users/franziskapellegrini/Dropbox/VitalBCI/mat/imag/';

DIROUT = '~/Dropbox/Franziska/MotorImag/Data_MI/';
if ~exist(DIROUT); mkdir(DIROUT); end

DIRFIG = '~/Dropbox/Franziska/MotorImag/Figures/Sensordata_MI/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

%classification performance scores 
load('/Users/franziskapellegrini/Dropbox/VitalBCI/mat/scores.mat')

dsRatio = 10;
nsub = 40 ;

DB_noise = db_motorImag_noisechans;
%%
for isub = 2:nsub %subject 1 not available 
    
    sub = ['vp' num2str(isub)];
    
    if strcmp(scores{isub}(1),'1') %if subject has a good classification performance 
        
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
        if ~(strcmp(mrk.className{1},'left')) || ~(strcmp(mrk.className{2},'right'))
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

 
        %manual rejection of bad channels 
        clear chans
        chans = fp_matchdbs_motorImag(DB_noise,sub);
        if ~isempty(chans)
            EEG = pop_select(EEG,'nochannel',chans);
            EEG = pop_interp(EEG, chanlocs);
        end
        
        %% plot on channel level 
        
        pop_spectopo(EEG, 1, [],'EEG' , 'percent', 100, 'freq', 10, 'freqrange',[0 50],'electrodes','on');
        outname = [DIRFIG sub '.png'];
        print(outname,'-dpng');
        close all

        %% save preprocessed EEG struct
        pop_saveset(EEG,'filename',['prep_' sub],'filepath',DIROUT)
        
    end
end
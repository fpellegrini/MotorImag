
% addpath('~/Dropbox/Franziska/Meditation/matlab/eeglab-develop/plugins/dipfit/standard_BEM/elec/');
% addpath('~/Dropbox/Franziska/Meditation/matlab/eeglab-develop/plugins/roiconnect/libs/brainstorm/');

clear all
% DIRIN = '/Users/franziskapellegrini/Dropbox/VitalBCI/mat/rest/';

DIROUT = '~/Dropbox/Franziska/MotorImag/Data/';
if ~exist(DIROUT); mkdir(DIROUT); end

DIRFIG = '~/Dropbox/Franziska/MotorImag/Figures/Sensordata/';
if ~exist(DIRFIG); mkdir(DIRFIG); end

dsRatio = 10;
% nsub = 40 ;

subs = [3 4 5 8 9 11 12 14 15 16 17 18 19 21 22 23 25 27 28 29 30 31 33 34 35 37];

% DB_oc = db_oc;
%%
isub = 31

sub = ['vp' num2str(isub)];

EEG = pop_loadset('filename',['prep_' sub '.set'],'filepath',DIROUT);
chanlocs = EEG(1).chanlocs;

% figure; topoplot([],EEG.chanlocs, 'style', 'blank',  'electrodes', 'numpoint', 'chaninfo', EEG.chaninfo);
  
%%
clear chans
% [chans, band] = fp_matchdbs_eyes(DB_oc,sub);
DB_noise = db_motorImag_noisechans;
chans = fp_matchdbs_motorImag(DB_noise,sub);
if ~isempty(chans)
    EEG = pop_select(EEG,'nochannel',chans);
    EEG = pop_interp(EEG, chanlocs);
end
%%
figure;
pop_spectopo(EEG, 1, [],'EEG' , 'percent', 100, 'freq', 10, 'freqrange',[0 50],'electrodes','on');

%%
outname = [DIRFIG sub '.png'];
print(outname,'-dpng');
close
pop_saveset(EEG,'filename',['prep_' sub],'filepath',DIROUT)
 

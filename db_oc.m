function Entries=db_oc()
% Manual noise chan selection. And manual frequency band detection.
% noiseChan index (EEG channel number)
% freq band in Hz 

Entries = {}; i = 1;

Entries{i} = {'vp1',[],[]}; i = i+1;
Entries{i} = {'vp2',[15],[10 14]}; i = i+1;
Entries{i} = {'vp3',[15],[9 13]}; i = i+1;
Entries{i} = {'vp4',[],[9 12]}; i = i+1;
Entries{i} = {'vp5',[],[10 13]}; i = i+1;
Entries{i} = {'vp6',[],[10 13]}; i = i+1;
Entries{i} = {'vp7',[],[9 13 ]}; i = i+1;
Entries{i} = {'vp8',[15,55],[9 12]}; i = i+1;
Entries{i} = {'vp9',[],[10 12]}; i = i+1;
Entries{i} = {'vp10',[],[8 12]}; i = i+1;
Entries{i} = {'vp11',[],[9 12]}; i = i+1;
Entries{i} = {'vp12',[14, 15],[7 11]}; i = i+1;
Entries{i} = {'vp13',[5,15,19,54],[9 12]}; i = i+1;
Entries{i} = {'vp14',[25],[8 11]}; i = i+1;
Entries{i} = {'vp15',[31],[10 13]}; i = i+1;
Entries{i} = {'vp16',[88],[9 12]}; i = i+1;
Entries{i} = {'vp17',[],[]}; i = i+1;
Entries{i} = {'vp18',[25],[9 12 ]}; i = i+1;
Entries{i} = {'vp19',[25],[9 12]}; i = i+1;
Entries{i} = {'vp20',[],[7 11]}; i = i+1;
Entries{i} = {'vp21',[],[9 12]}; i = i+1;
Entries{i} = {'vp22',[25],[9 12]}; i = i+1;
Entries{i} = {'vp23',[25],[9 13]}; i = i+1;
Entries{i} = {'vp24',[64],[10 13]}; i = i+1;
Entries{i} = {'vp25',[18,25,29,31,88],[9 12]}; i = i+1;
Entries{i} = {'vp26',[4,14,19],[10 13 ]}; i = i+1;
Entries{i} = {'vp27',[],[]}; i = i+1;
Entries{i} = {'vp28',[],[9 12]}; i = i+1;
Entries{i} = {'vp29',[],[7 11]}; i = i+1;
Entries{i} = {'vp30',[],[8 11]}; i = i+1;
Entries{i} = {'vp31',[],[]}; i = i+1;
Entries{i} = {'vp32',[],[]}; i = i+1;
Entries{i} = {'vp33',[],[7 11]}; i = i+1;
Entries{i} = {'vp34',[],[9 13]}; i = i+1;
Entries{i} = {'vp35',[],[9 11]}; i = i+1;
Entries{i} = {'vp36',[],[8 12]}; i = i+1;
Entries{i} = {'vp37',[],[8 13]}; i = i+1;
Entries{i} = {'vp38',[],[8 12]}; i = i+1;
Entries{i} = {'vp39',[],[8 12]}; i = i+1;
Entries{i} = {'vp40',[],[10 13]}; i = i+1;
function Entries=db_motorImag_noisechans()
% Manual noise chan selection.
% noiseChan index (EEG channel number)

Entries = {}; i = 1;

Entries{i} = {'vp3',[15]}; i = i+1;
Entries{i} = {'vp4',[15]}; i = i+1;
Entries{i} = {'vp8',[15,55]}; i = i+1;
Entries{i} = {'vp9',[15,19,48]}; i = i+1;
Entries{i} = {'vp12',[15]}; i = i+1;
Entries{i} = {'vp14',[25,34,88]}; i = i+1;
Entries{i} = {'vp16',[25,88]}; i = i+1;
Entries{i} = {'vp17',[25,88,64,87,89]}; i = i+1;
Entries{i} = {'vp18',[25,88]}; i = i+1;
Entries{i} = {'vp19',[25,64,72,88]}; i = i+1;
Entries{i} = {'vp21',[15]}; i = i+1;
Entries{i} = {'vp22',[25,64,88]}; i = i+1;
Entries{i} = {'vp25',[31]}; i = i+1;
Entries{i} = {'vp28',[81]}; i = i+1;
Entries{i} = {'vp31',[4]}; i = i+1;
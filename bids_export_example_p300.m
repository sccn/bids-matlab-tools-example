
% Matlab script to export to BIDS - tutorial and unit test case
% Arnaud Delorme - Oct 2020
clear

data = [];
data(end+1).file = {'s1_run1.bdf' 's1_run2.bdf' 's1_run3.bdf'};
data(end  ).session = [1 1 1];
data(end  ).run     = [1 2 3];
data(end  ).notes   = { 'She changed push button hands during the experiment (in the middle of trials)' };

data(end+1).file = {'s2_run1.bdf' 's2_run2.bdf' 's2_run3.bdf'};
data(end  ).session = [1 1 1];
data(end  ).run     = [1 2 3];
data(end  ).notes   = { 'First ~120 seconds did not have push button triggers because the USB cable was not connected' 'She moves around when she s starting to feel sleepy. She said that she was dozing and her head moved from side to side.' 'Had to interrupt the session because she stopped pressing the button during the oddball sounds. She fell asleep in the middle of the experiment.' };

% Content for README file
README = [ 'Data collection took place at the Meditation Research Institute (MRI) in Rishikesh, India under the supervision of Arnaud Delorme, PhD. The project was approved by the local MRI Indian ethical committee and the ethical committee of the University of California San Diego (IRB project # 090731).' 10 10 ...
'Participants sat either on a blanket on the floor or on a chair for both experimental periods depending on their personal preference. They were asked to keep their eyes closed and all lighting in the room was turned off during data collection. An intercom allowed communication between the experimental and the recording room.' 10 10 ...
'Participants performed three identical sessions of 13 minutes each. 750 stimuli were presented with 70% of them being standard (500 Hz pure tone lasting 60 milliseconds), 15% being oddball (1000 Hz pure tone lasting 60 ms) and 15% being distractors (1000 Hz white noise lasting 60 ms). All sounds took 5 milliseconds to ramp up and 5 milliseconds to ramp down. Sounds were presented at a rate of 1 per second with a random gaussian jitter of standard deviation 25 ms. Participants were instructed to respond to oddball by pressing a key on a keypad that was resting on their lap.' 10 10 ... 
];

% general information for dataset_description.json file
generalInfo.Name = 'P300 sound task';
generalInfo.ReferencesAndLinks = { 'No bibliographic reference other than the DOI for this dataset' };
generalInfo.BIDSVersion = 'v1.2.1';
generalInfo.License = 'CC0';
generalInfo.Authors = {'Arnaud Delorme' };

% Task information for xxxx-eeg.json file
tInfo.InstitutionAddress = 'Pavillon Baudot CHU Purpan, BP 25202, 31052 Toulouse Cedex';
tInfo.InstitutionName = 'Paul Sabatier Universite';
tInfo.InstitutionalDepartmentName = 'Centre de Recherche Cerveau et Cognition';
tInfo.PowerLineFrequency = 50;
tInfo.ManufacturersModelName = 'Biosemi Active 2';

% participant information for participants.tsv file
pInfo = { 'gender' 'age' 'Ethnicity' 'Air_conditioning';
 'F' 44 'Indian'        'on';
 'F' 32 'Indian'        'on' };

% participant column description for participants.json file
pInfoDesc.participant_id.LongName    = 'Participant identifier';
pInfoDesc.participant_id.Description = 'Unique participant identifier';

pInfoDesc.gender.Description = 'Sex of the participant';
pInfoDesc.gender.Levels.M    = 'male';
pInfoDesc.gender.Levels.F    = 'female';

pInfoDesc.age.Description = 'age of the participant';
pInfoDesc.age.Units       = 'years';

pInfoDesc.Air_conditioning.Description = 'Ethnicity of participants';
pInfoDesc.Ethnicity.Levels.Indian        = 'Participant of Indian origin';
pInfoDesc.Ethnicity.Levels.Non_indian    = 'Participant of non-Indian origin (Caucasian, etc...)';

pInfoDesc.Air_conditioning.Description = 'Air Conditioning - could create interference so noted here';
pInfoDesc.Air_conditioning.Levels.on   = 'Air Conditioning was on  - temperature at or below 25C';
pInfoDesc.Air_conditioning.Levels.off  = 'Air Conditioning was off - temperature at or above 25C';

% event column description for xxx-events.json file (only one such file)
eInfo = {'onset'         'latency';
         'sample'        'latency';
         'value'         'type' }; 

eInfoDesc.onset.Description = 'Event onset';
eInfoDesc.onset.Units = 'second';

eInfoDesc.response_time.Description = 'Latency of button press after auditory stimulus';
eInfoDesc.response_time.Levels.Units = 'millisecond';

eInfoDesc.trial_type.Description = 'Type of event';
eInfoDesc.trial_type.Levels.stimulus = 'Auditory stimulus';
eInfoDesc.trial_type.Levels.responses = 'Behavioral response';

eInfoDesc.value.Description = 'Value of event';
eInfoDesc.value.Levels.response   = 'Response of the subject';
eInfoDesc.value.Levels.standard   = 'Standard at 500 hz for 60 ms';
eInfoDesc.value.Levels.ignore     = 'Ignore - not a real event';
eInfoDesc.value.Levels.oddball    = 'Oddball at 1000 hz for 60 ms';
eInfoDesc.value.Levels.noise      = 'White noise for 60 ms';

renameTypes = { 'condition 1' 'response';
                'condition 2' 'standard';
                'condition 3' 'ignore';
                'condition 4' 'oddball';
                'condition 8' 'noise' };

trialTypes = { 'condition 1' 'response';
               'condition 2' 'stimulus';
               'condition 3' 'n/a';
               'condition 4' 'stimulus';
               'condition 8' 'stimulus' };

% Code Files used to preprocess and import to BIDS
codefiles = { fullfile(pwd, mfilename) fullfile(pwd, 'oddball_psychotoolbox.m') };

% Content for CHANGES file
CHANGES = sprintf([ 'Version 1.0 - 4 Aug 2020\n' ...
                    ' - Initial release\n' ]);

% call to the export function
targetFolder =  '../BIDS_export';
dipfitdefs;
bids_export(data, ...
    'targetdir', targetFolder, ...
    'taskName', 'P300',...
    'gInfo', generalInfo, ...
    'pInfo', pInfo, ...
    'pInfoDesc', pInfoDesc, ...
    'eInfo', eInfo, ...
    'eInfoDesc', eInfoDesc, ...
    'README', README, ...
    'CHANGES', CHANGES, ...
    'codefiles', codefiles, ...
    'trialtype', trialTypes, ...
    'chanlookup', template_models(2).chanfile, ...
    'renametype', renameTypes, ...
    'checkresponse', 'condition 1', ...
    'tInfo', tInfo, ...
    'copydata', 1);

% original export
eeglab
bids_export_example_p300;

% first import
[STUDY1, ALLEEG1] = pop_importbids('./BIDS_EXPORT');

% second export
pop_exportbids(STUDY1, ALLEEG1, 'targetdir', './bidsreexport');

% second import
[STUDY2, ALLEEG2] = pop_importbids('./bidsreexport');

% check STUDY
STUDY1.filename = {}; STUDY1.filepath = {};
STUDY1.datasetinfo = rmfield(STUDY1.datasetinfo, 'filepath');
STUDY2.filename = {}; STUDY2.filepath = {};
STUDY2.datasetinfo = rmfield(STUDY2.datasetinfo, 'filepath');

stdEq = isequaln(STUDY1, STUDY2);

% check ALLEEG
ALLEEG1 = rmfield(ALLEEG1, 'filepath');
ALLEEG2 = rmfield(ALLEEG2, 'filepath');
alleegEq = isequaln(ALLEEG1, ALLEEG2);

if ~alleegEq
    for compIdx = 1:length(ALLEEG1)
        fprintf('Dataset %d:\n', compIdx)
        eeg_compare(ALLEEG1(compIdx), ALLEEG2(compIdx));
    end
end
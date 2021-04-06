% original export
bids_export_example_p300;

% first import
STUDY = pop_bidsimport('./BIDS_EXPORT');

% second export
STUDY = pop_bidsexport('./BIDS_EXPORT');

% second import
STUDY = pop_bidsimport('./BIDS_EXPORT');

% check structures

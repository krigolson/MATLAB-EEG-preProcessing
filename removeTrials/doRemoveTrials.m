function EEG = doRemoveTrials(EEG,maximumNumberOfTrials)

% function by Olave Krigolson
% this function is to remove all trials above a certain count, the purpose
% is to allow the study of the impact of minimal trial numbers, i.e., does
% your ERP look the same with 200 trials, 150 trials, 100 trials, etc.

    EEG.trials = maximumNumberOfTrials;
    EEG.data(:,:,maximumNumberOfTrials+1:end) = [];
    EEG.epoch(maximumNumberOfTrials+1:end) = [];

end
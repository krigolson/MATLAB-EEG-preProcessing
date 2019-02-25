function inputData = doEpochData(inputData,epochMarkers,epochTimes)

    % by Olave Krigolson
    % function to run EEGLABs pop_epoch fundtion to convert the continuous matrix into epoched data
    % did fix this so that it is in ms so epoch times could be [-200 1000];
    % markers are in EEGLAB format, i.e., {'5','6'}
    
    epochTimes = epochTimes / 1000;

    inputData = pop_epoch(inputData,epochMarkers,epochTimes);
    
    inputData.epochMarkers = epochMarkers;
    inputData.epochTimes = epochTimes;
    
    disp('EEG data has been epoched...');
        
end
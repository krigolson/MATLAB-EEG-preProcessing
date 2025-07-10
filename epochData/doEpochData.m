function EEG = doEpochData(EEG,epochMarkers,epochTimes)

    % by Olave Krigolson, March 19, 2019
    % function to replace pop_epoch as it has problems dealing with
    % overlapped segments.
    
    % use markers in the following format
    % epochMarkers = {'S  5','S 15','S 25','S 35'};
    % use times in the following format in ms which the function will
    % convert to seconds for you. So, to get -200 to 600 use -200 to 600.
    % Note, you can work in seconds as well.

    % covert to seconds if needed
    if abs(epochTimes(1)) > 100
        epochTimes = epochTimes / 1000;
    end

    % call EEGLAB function
    EEG = pop_epoch(EEG,epochMarkers,epochTimes);
    
    % store some stuff
    EEG.epochMarkers = epochMarkers;
    EEG.epochTimes = epochTimes;
        
end
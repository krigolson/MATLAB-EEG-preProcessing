function EEG = doEpochData(EEG,epochMarkers,epochTimes)

    % by Olave Krigolson, March 19, 2019
    % function to replace pop_epoch as it has problems dealing with
    % overlapped segments.
    
    % use markers in the following format
    % epochMarkers = {'S  5','S 15','S 25','S 35'};
    % use times in the following format
    % epochTimes = [-0.2 0.6];

    EEG = pop_epoch(EEG,epochMarkers,epochTimes);
    
   
    EEG.epochMarkers = epochMarkers;
    EEG.epochTimes = epochTimes;
        
end
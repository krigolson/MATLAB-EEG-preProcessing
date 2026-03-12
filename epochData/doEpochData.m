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

    % -------------------------------------------------------------------------
    % Step 1: Keep only the time-locking event (latency == 0) in each epoch
    % -------------------------------------------------------------------------
    for i = 1:length(EEG.epoch)
        lats = cell2mat(EEG.epoch(i).eventlatency);
        idx  = find(lats == 0);
    
        EEG.epoch(i).event         = EEG.epoch(i).event(idx);
        EEG.epoch(i).eventlatency  = EEG.epoch(i).eventlatency(idx);
        EEG.epoch(i).eventtype     = EEG.epoch(i).eventtype(idx);
        EEG.epoch(i).eventduration = EEG.epoch(i).eventduration(idx);
        EEG.epoch(i).eventchannel  = EEG.epoch(i).eventchannel(idx);
        EEG.epoch(i).eventbvtime   = EEG.epoch(i).eventbvtime(idx);
        EEG.epoch(i).eventbvmknum  = EEG.epoch(i).eventbvmknum(idx);
        EEG.epoch(i).eventcode     = EEG.epoch(i).eventcode(idx);
    
        % Handle eventurvent if present
        if isfield(EEG.epoch(i), 'eventurvent')
            EEG.epoch(i).eventurvent = EEG.epoch(i).eventurvent(idx);
        end
    end
    
    % -------------------------------------------------------------------------
    % Step 2: Unwrap remaining 1x1 cells to plain scalars
    % -------------------------------------------------------------------------
    for i = 1:length(EEG.epoch)
        EEG.epoch(i).eventlatency  = cell2mat(EEG.epoch(i).eventlatency);
        EEG.epoch(i).eventduration = cell2mat(EEG.epoch(i).eventduration);
        EEG.epoch(i).eventchannel  = cell2mat(EEG.epoch(i).eventchannel);
        EEG.epoch(i).eventbvtime   = cell2mat(EEG.epoch(i).eventbvtime);
        EEG.epoch(i).eventbvmknum  = cell2mat(EEG.epoch(i).eventbvmknum);
    end
    
    % store some stuff
    EEG.epochMarkers = epochMarkers;
    EEG.epochTimes = epochTimes;
        
end
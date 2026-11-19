function EEG = doEpochData(EEG,epochMarkers,epochTimes)
    % by Olave Krigolson, March 19, 2019
    % function to replace pop_epoch as it has problems dealing with
    % overlapped segments.
    
    % use markers in the following format
    % epochMarkers = {'S  5','S 15','S 25','S 35'};
    % use times in ms or in seconds. If either limit is larger than 10 in
    % absolute value the window is assumed to be in ms and is converted to
    % seconds for you. So, to get -200 to 600 ms use [-200 600] or
    % [-0.2 0.6], and [-100 600] is also read as ms. Windows in seconds
    % that extend past 10 s must therefore be passed to pop_epoch directly.
    % covert to seconds if needed
    if max(abs(epochTimes)) > 10
        epochTimes = epochTimes / 1000;
    end
    % call EEGLAB function
    EEG = pop_epoch(EEG,epochMarkers,epochTimes);
    % -------------------------------------------------------------------------
    % Step 1: Keep only the time-locking event in each epoch
    % -------------------------------------------------------------------------
    % pop_epoch lists every event that falls inside an epoch, so overlapped
    % segments end up with several events each. Downstream code (doERP,
    % doMarkerSummary) expects one event per epoch: the requested marker at
    % time zero.
    timeLockTol = 1e-9;
    epochFieldNames = fieldnames(EEG.epoch);
    eventFields = epochFieldNames(startsWith(epochFieldNames, 'event'));
    epochMarkersString = string(epochMarkers);
    for i = 1:length(EEG.epoch)
        nEvents = numel(EEG.epoch(i).event);
        if nEvents > 1
            lats = doEpochEnsureNumericVector(EEG.epoch(i).eventlatency);
            eventTypes = string(doEpochCellToStringCell(EEG.epoch(i).eventtype));
            isMarker = ismember(eventTypes(:)', epochMarkersString(:)');
            atZero = abs(lats(:)') <= timeLockTol;
            % Prefer a requested marker at time zero, then any event at time
            % zero, then (for floating-point shifts) the requested marker
            % nearest to zero, then the nearest event of any type.
            idxKeep = find(isMarker & atZero, 1, 'first');
            if isempty(idxKeep)
                idxKeep = find(atZero, 1, 'first');
            end
            if isempty(idxKeep) && any(isMarker)
                candidates = find(isMarker);
                [~, nearest] = min(abs(lats(candidates)));
                idxKeep = candidates(nearest);
            end
            if isempty(idxKeep)
                [~, idxKeep] = min(abs(lats));
            end
            % Keep that event in every event* field that holds one entry
            % per event. Character fields are a single value, not a list,
            % so they are never indexed.
            for fieldCounter = 1:numel(eventFields)
                fieldName = eventFields{fieldCounter};
                fieldValue = EEG.epoch(i).(fieldName);
                if ~ischar(fieldValue) && numel(fieldValue) == nEvents
                    EEG.epoch(i).(fieldName) = fieldValue(idxKeep);
                end
            end
        end
    end
    
    % -------------------------------------------------------------------------
    % Step 2: Unwrap remaining 1x1 cells to plain values
    % -------------------------------------------------------------------------
    for i = 1:length(EEG.epoch)
        for fieldCounter = 1:numel(eventFields)
            fieldName = eventFields{fieldCounter};
            EEG.epoch(i).(fieldName) = doEpochCellScalarToValue(EEG.epoch(i).(fieldName));
        end
    end
    
    % store some stuff
    EEG.epochMarkers = epochMarkers;
    EEG.epochTimes = epochTimes;
        
end
function values = doEpochEnsureNumericVector(inputValues)
    if iscell(inputValues)
        values = cellfun(@doEpochNumericFromAny, inputValues);
    elseif isnumeric(inputValues)
        values = inputValues(:)';
    else
        values = doEpochNumericFromAny(inputValues);
    end
end
function outputValue = doEpochCellScalarToValue(inputValue)
    outputValue = inputValue;
    if iscell(inputValue) && numel(inputValue) == 1
        outputValue = inputValue{1};
    end
end
function values = doEpochCellToStringCell(inputValues)
    if iscell(inputValues)
        values = cellfun(@(x) string(x), inputValues, 'UniformOutput', false);
    else
        values = {string(inputValues)};
    end
end
function numericValue = doEpochNumericFromAny(value)
    if isnumeric(value)
        numericValue = double(value);
    else
        numericValue = str2double(string(value));
    end
end
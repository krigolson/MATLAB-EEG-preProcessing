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
    % Step 1: Keep only selected marker events, then one time-locking event
    % -------------------------------------------------------------------------
    timeLockTol = 1e-9;
    epochFieldNames = fieldnames(EEG.epoch);
    eventFields = epochFieldNames(startsWith(epochFieldNames, 'event'));

    epochMarkersString = string(epochMarkers);

    for i = 1:length(EEG.epoch)
        lats = doEpochEnsureNumericVector(EEG.epoch(i).eventlatency);
        eventTypes = doEpochCellToStringCell(EEG.epoch(i).eventtype);
        eventTypes = string(eventTypes);

        % Keep only events from requested ERP markers.
        idxSelected = find(ismember(eventTypes, epochMarkersString));
        if ~isempty(idxSelected)
            for fieldCounter = 1:numel(eventFields)
                fieldName = eventFields{fieldCounter};
                fieldValue = EEG.epoch(i).(fieldName);
                nElements = numel(fieldValue);
                if nElements > 1
                    validIdx = idxSelected(idxSelected <= nElements);
                    if ~isempty(validIdx)
                        EEG.epoch(i).(fieldName) = fieldValue(validIdx);
                    end
                end
            end

            % Refresh local variables after marker filtering.
            lats = doEpochEnsureNumericVector(EEG.epoch(i).eventlatency);
            eventTypes = doEpochCellToStringCell(EEG.epoch(i).eventtype);
            eventTypes = string(eventTypes);
        end

        % Candidates are events closest to time zero.
        idxZero = find(abs(lats) <= timeLockTol);

        % If multiple events are at zero, prioritize requested markers.
        if numel(idxZero) > 1
            markerIdx = find(ismember(eventTypes(idxZero), epochMarkersString), 1, 'first');
            if ~isempty(markerIdx)
                idxKeep = idxZero(markerIdx);
            else
                idxKeep = idxZero(1);
            end
        elseif numel(idxZero) == 1
            idxKeep = idxZero;
        else
            % Fallback for floating-point shifts: keep nearest to zero.
            [~, idxKeep] = min(abs(lats));
        end

        % Keep selected index for all event* fields that are indexed per event.
        for fieldCounter = 1:numel(eventFields)
            fieldName = eventFields{fieldCounter};
            fieldValue = EEG.epoch(i).(fieldName);
            nElements = numel(fieldValue);

            if nElements > 1 && idxKeep <= nElements
                EEG.epoch(i).(fieldName) = fieldValue(idxKeep);
            end
        end
    end
    
    % -------------------------------------------------------------------------
    % Step 2: Unwrap remaining 1x1 cells to plain scalars
    % -------------------------------------------------------------------------
    for i = 1:length(EEG.epoch)
        if isfield(EEG.epoch(i), 'eventlatency')
            EEG.epoch(i).eventlatency = doEpochCellScalarToValue(EEG.epoch(i).eventlatency);
        end
        if isfield(EEG.epoch(i), 'eventduration')
            EEG.epoch(i).eventduration = doEpochCellScalarToValue(EEG.epoch(i).eventduration);
        end
        if isfield(EEG.epoch(i), 'eventchannel')
            EEG.epoch(i).eventchannel = doEpochCellScalarToValue(EEG.epoch(i).eventchannel);
        end
        if isfield(EEG.epoch(i), 'eventbvtime')
            EEG.epoch(i).eventbvtime = doEpochCellScalarToValue(EEG.epoch(i).eventbvtime);
        end
        if isfield(EEG.epoch(i), 'eventbvmknum')
            EEG.epoch(i).eventbvmknum = doEpochCellScalarToValue(EEG.epoch(i).eventbvmknum);
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
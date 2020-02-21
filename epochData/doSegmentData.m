function EEG = doSegmentData(EEG,epochMarkers,epochTimes)

    % by Olave Krigolson, March 19, 2019
    % function to replace pop_epoch as it has problems dealing with
    % overlapped segments.
    
    startPoint = round(epochTimes(1)*EEG.srate/1000);
    endPoint = round(epochTimes(2)*EEG.srate/1000);
    
    tempData = [];
    epochCounter = 1;
    tempMarkers = [];
    
    for markerCounter = 1:size(epochMarkers,2)
        
        for segmentCounter = 1:size(EEG.event,2)
            
            % force conversion to string for consitency
            if isstring(EEG.event(segmentCounter).type) || ischar(EEG.event(segmentCounter).type)
            else
                EEG.event(segmentCounter).type = string(EEG.event(segmentCounter).type);
            end
            
            if strcmp(EEG.event(segmentCounter).type,epochMarkers{markerCounter})
                
                tempSegment = [];
                currentLatency = round(EEG.event(segmentCounter).latency);
                tempSegment = EEG.data(:,currentLatency+startPoint:currentLatency+endPoint);
                tempData(:,:,epochCounter) = tempSegment;
                EEG.epoch(epochCounter).event = epochCounter;
                EEG.epoch(epochCounter).eventlatency = 0;
                EEG.epoch(epochCounter).eventduration = abs(epochTimes(2) - epochTimes(1))/1000;
                EEG.epoch(epochCounter).eventchannel = 0;
                if isfield(EEG.event,'bvtime')
                    EEG.epoch(epochCounter).eventbvtime = EEG.event(segmentCounter).bvtime;
                end
                if isfield(EEG.event,'bvmknum')
                    EEG.epoch(epochCounter).eventbvmknum = EEG.event(segmentCounter).bvmknum;
                end
                EEG.epoch(epochCounter).eventtype = EEG.event(segmentCounter).type;
                if isfield(EEG.event,'code')
                    EEG.epoch(epochCounter).eventcode = EEG.event(segmentCounter).code;
                end
                EEG.epoch(epochCounter).eventurevent = EEG.event(segmentCounter).urevent;
                
                tempMarkers(epochCounter,1) = epochCounter;
                if isfield(EEG.event,'code')
                    if strcmp(EEG.event(segmentCounter).code,'Stimulus')
                        tempEvent = EEG.event(segmentCounter).type;
                        tempEvent = strip(tempEvent);
                        if strcmp(tempEvent(1),'S')
                            tempEvent(1) = [];
                        end
                        tempMarkers(epochCounter,2) = str2num(tempEvent);
                    end
                else
                    tempMarkers(epochCounter,2) = EEG.epoch(epochCounter).eventtype;
                end
                
                epochCounter = epochCounter + 1;
                
            end
            
        end
        
    end
    
    if isfield(EEG,'allMarkers') == 1
        EEG.allMarkers = [];
        EEG.allMarkers = tempMarkers;
    end

    EEG.data = [];
    EEG.data = tempData;
    EEG.pnts = size(tempData,2);
    EEG.trials = size(tempData,3);
    times(1) = epochTimes(1)/1000;
    for counter = 2:size(tempData,2)
        times(counter) = times(counter-1) + 1/EEG.srate;
    end
    EEG.times = times;
    EEG.xmin = min(times);
    EEG.xmax = max(times);
    EEG.epochMarkers = epochMarkers;
    EEG.epochTimes = epochTimes;
        
end
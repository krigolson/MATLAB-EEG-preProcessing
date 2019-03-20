function inputData = doSegmentData(inputData,epochMarkers,epochTimes)

    % by Olave Krigolson
    % function to run EEGLABs pop_epoch fundtion to convert the continuous matrix into epoched data
    % did fix this so that it is in ms so epoch times could be [-200 1000];
    % markers are in EEGLAB format, i.e., {'5','6'}
    
    startPoint = round(epochTimes(1)*inputData.srate/1000);
    endPoint = round(epochTimes(2)*inputData.srate/1000);
    
    tempData = [];
    epochCounter = 1;
    
    for markerCounter = 1:size(epochMarkers,2)
        
        for segmentCounter = 1:size(inputData.event,2)
            
            if strcmp(inputData.event(segmentCounter).type,epochMarkers{markerCounter})
                
                tempSegment = [];
                currentLatency = inputData.event(segmentCounter).latency;
                tempSegment = inputData.data(:,currentLatency+startPoint:currentLatency+endPoint);
                tempData(:,:,epochCounter) = tempSegment;
                inputData.epoch(epochCounter).event = epochCounter;
                inputData.epoch(epochCounter).eventlatency = 0;
                inputData.epoch(epochCounter).eventduration = (abs(epochTimes(1) + abs(epochTimes(2))))/1000;
                inputData.epoch(epochCounter).eventchannel = 0;
                inputData.epoch(epochCounter).eventbvtime = inputData.event(segmentCounter).bvtime;
                inputData.epoch(epochCounter).eventbvmknum = inputData.event(segmentCounter).bvmknum;
                inputData.epoch(epochCounter).eventtype = inputData.event(segmentCounter).type;
                inputData.epoch(epochCounter).eventcode = inputData.event(segmentCounter).code;
                inputData.epoch(epochCounter).eventurevent = inputData.event(segmentCounter).urevent;
                
                epochCounter = epochCounter + 1;
                
            end
            
        end
        
    end

    inputData.data = [];
    inputData.data = tempData;
    inputData.pnts = size(tempData,2);
    inputData.trials = size(tempData,3);
    times(1) = epochTimes(1)/1000;
    for counter = 2:size(tempData,2)
        times(counter) = times(counter-1) + 1/inputData.srate;
    end
    inputData.times = times;
    inputData.xmin = min(times);
    inputData.xmax = max(times);
    inputData.epochMarkers = epochMarkers;
    inputData.epochTimes = epochTimes;
    
    disp('EEG data has been epoched...');
        
end
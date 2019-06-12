function [EEG] = doTemporalEpochs(EEG,timeWindow,overLap)

    
    % by Olave Krigolson, June 12, 2019
    % function to take continuous EEG and split it into a series of a time
    % epochs with overLap as series
    % provide a time window in ms and over lap in ms. The overlap is the
    % amount of time in ms that you want to shift the window. Set same as
    % timeWindow for no overlal
    
    nPoints = round((timeWindow / 1000) * EEG.srate);
    nOverLap = round(overLap / 1000 * EEG.srate);
    
    startPoint = 1;
    endPoint = nPoints;
    
    dataLength = size(EEG.data,2);
    
    tempData = [];
    epochCounter = 1;
    tempMarkers = [];
    
    while endPoint <= dataLength
                
        tempSegment = [];
        tempSegment = EEG.data(:,startPoint:endPoint);
        tempData(:,:,epochCounter) = tempSegment;
        
        EEG.epoch(epochCounter).event = epochCounter;
        EEG.epoch(epochCounter).eventlatency = 0;
        EEG.epoch(epochCounter).eventduration = timeWindow/1000;
        EEG.epoch(epochCounter).eventchannel = 0;
        EEG.epoch(epochCounter).eventbvtime = 0;
        EEG.epoch(epochCounter).eventbvmknum = 0;
        EEG.epoch(epochCounter).eventtype = 'Epuch';
        EEG.epoch(epochCounter).eventcode = 1;
        EEG.epoch(epochCounter).eventtype = '1';
        EEG.epoch(epochCounter).eventurevent = '1';
                
        tempMarkers(epochCounter,1) = epochCounter;
        tempMarkers(epochCounter,2) = 1;
                
        epochCounter = epochCounter + 1;
        
        startPoint = startPoint + nOverLap;
        endPoint = endPoint + nOverLap;
                
    end
    
    if isfield(EEG,'allMarkers') == 1
        EEG.allMarkers = [];
        EEG.allMarkers = tempMarkers;
    end

    EEG.data = [];
    EEG.data = tempData;
    EEG.pnts = size(tempData,2);
    EEG.trials = size(tempData,3);
    times(1) = 0;
    for counter = 2:size(tempData,2)
        times(counter) = times(counter-1) + 1/EEG.srate;
    end
    EEG.times = times;
    EEG.xmin = min(times);
    EEG.xmax = max(times);
    EEG.epochMarkers = '1';
    EEG.epochTimes = [timeWindow overLap];
    
end
        
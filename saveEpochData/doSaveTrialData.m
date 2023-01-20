function doSaveTrialData(EEG,fileName)

    % strip epoch markers of text
    
    trialData.data = EEG.data;
    trialData.epoch = EEG.epoch;
    trialData.segmentMarkers = EEG.segmentMarkers;
    trialData.epochMarkers = EEG.epochMarkers;
    trialData.originalTrials = sum(EEG.epochMarkers);
    trialData.actualTrials = size(EEG.data,3);
    
    save([fileName '_trialData'],'trialData');
    
end
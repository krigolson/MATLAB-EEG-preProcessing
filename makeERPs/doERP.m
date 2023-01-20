function ERP = doERP(inputData,markers,optionFlag)

    % written as a shell by Olav Krigolson
    % makes ERPs based on markers
    % if optionFlag = 1 then do odd and even averages as extra conditions
    % to allow for internal consistency calculations
    
    numberOfConditions = size(markers,2);
    numberOfEpochs = size(inputData.data,3);
    
    for conditionCounter = 1:numberOfConditions
        
        tempData = [];
        tempDataCounter = 1;
        
        for epochCounter = 1:numberOfEpochs
    
            if strcmp(markers(conditionCounter),inputData.epoch(epochCounter).eventtype)
            
                tempData(:,:,tempDataCounter) = inputData.data(:,:,epochCounter);
                tempDataCounter = tempDataCounter + 1;
                
            end
            
        end
        
        if isempty(tempData)
            ERP.data(:,:,conditionCounter) = NaN(size(inputData.data,1),size(inputData.data,2));
        else
            ERP.data(:,:,conditionCounter) = nanmean(tempData,3);
        end
        ERP.epochCount(conditionCounter) = tempDataCounter - 1;
        
        if optionFlag == 1
            odds = [1:2:size(tempData,3)];
            evens = [2:2:size(tempData,3)];
            evenData = nanmean(tempData(:,:,evens),3);
            oddData = nanmean(tempData(:,:,odds),3);
            ERP.data(:,:,conditionCounter+numberOfConditions) = oddData;
            ERP.data(:,:,conditionCounter+(2*numberOfConditions)) = evenData;
        end
        
    end
    
    ERP.trialData = EEG.data;
    ERP.epochs = EEG.epochs;
    ERP.markers = EEG.segmentMarkers;
    ERP.originalEpochs = EEG.trials;
    ERP.totalEpochs = numberOfEpochs;
    ERP.chanlocs = inputData.chanlocs;
    ERP.srate = inputData.srate;
    ERP.epochTime(1) = inputData.xmin;
    ERP.epochTime(2) = inputData.xmax;
    ERP.times = inputData.times;
    
end
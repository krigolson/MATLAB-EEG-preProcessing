function ERP = doERP(inputData,markers)

    % written as a shell by Olav Krigolson
    % makes ERPs based on markers
    
    numberOfConditions = size(markers,2);
    numberOfEpochs = size(inputData.data,3);
    
    for conditionCounter = 1:numberOfConditions
        
        tempData = [];
        tempDataCounter = 1;
        
        for epochCounter = 1:numberOfEpochs
    
            if strcmp(markers(conditionCounter),inputData.event(epochCounter).type)
            
                tempData(:,:,tempDataCounter) = inputData.data(:,:,epochCounter);
                tempDataCounter = tempDataCounter + 1;
                
            end
            
        end
        
        ERP.data(:,:,conditionCounter) = mean(tempData,3);
        ERP.epochCount(conditionCounter) = tempDataCounter - 1;
        
    end
    
    ERP.totalEpochs = numberOfEpochs;
    ERP.chanlocs = inputData.chanlocs;
    ERP.srate = inputData.srate;
    ERP.epochTime(1) = inputData.xmin;
    ERP.epochTime(2) = inputData.xmax;
    ERP.times = inputData.times;
    
    disp('ERPs have now been created...');
    
end
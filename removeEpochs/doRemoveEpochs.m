function inputData = doRemoveEpochs(inputData,removalMatrix)

    % written as a shell by Olav Krigolson
    % uses an input vector to remove trials from EEG data set
    
    removalVector = sum(removalMatrix,1);
    numberOfEpochs = size(inputData.data,3);
    
    for epochCounter = numberOfEpochs:-1:1
    
        if removalVector(epochCounter) ~= 0
            
            inputData.data(:,:,epochCounter) = [];
            inputData.event(epochCounter) = [];
            
        end
        
    end
    
    inputData.channelArtifactPercentages = sum(removalMatrix,2)/numberOfEpochs*100;
    
    disp('EEG epochs have now been removed...');
    
end
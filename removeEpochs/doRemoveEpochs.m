function inputData = doRemoveEpochs(inputData,removalMatrix)

    % written as a shell by Olav Krigolson
    % uses an input vector to remove trials from EEG data set
    
    removalVector = sum(removalMatrix,1);
    numberOfEpochs = size(inputData.data,3);
    checkCounter = numberOfEpochs;
    
    for epochCounter = numberOfEpochs:-1:1
    
        if removalVector(epochCounter) ~= 0
            
            inputData.data(:,:,epochCounter) = [];
            inputData.event(epochCounter) = [];
            checkCounter = checkCounter - 1;
            
        end
        
    end
    
    inputData.channelArtifactPercentages = sum(removalMatrix,2)/numberOfEpochs*100;
    
    if checkCounter == 0
        disp('ALL TRIAL HAVE BEEN REMOVED!!!! Recommend interpolation or participant removal from analysis');
        badChannels = find(inputData.channelArtifactPercentages >= 100);
        disp('The following channels have too many artifacts:');
        inputData.chanlocs(badChannels).labels
        pause;
        return
    end
    
    disp('EEG epochs have now been removed...');
    
end
function inputData = doRemoveEpochs(inputData,removalMatrix,optionFlag)

    % written as a shell by Olav Krigolson
    % uses an input vector to remove trials from EEG data set base on an
    % artifact criteria
    % set option flag to be equal to 0 if you want to remove all channels
    % for a given "bad" epoch, set option flag to 1 to replace bad channel
    % data with NaNs (i.e., seperate channel averaging), note this is
    % typically not recommended as the blinks typically impact all channels
    % to some extent
    
    numberOfEpochs = size(inputData.data,3);
    checkCounter = numberOfEpochs;
    
    if optionFlag == 0
    
        removalVector = sum(removalMatrix,1);

        for epochCounter = numberOfEpochs:-1:1

            if removalVector(epochCounter) ~= 0

                inputData.data(:,:,epochCounter) = [];
                inputData.epoch(epochCounter) = [];
                checkCounter = checkCounter - 1;

                if isfield(inputData,'segmentMarkers') == 1
                    inputData.segmentMarkers(epochCounter,:) = [];
                end

            end

        end
    end
    if optionFlag == 1
        
        for epochCounter = numberOfEpochs:-1:1
            
            isBad = 0;
            
            for channelCounter = 1:size(inputData,1)
                
                if removalMatrix(channelCounter,epochCounter) ~= 0
                    
                    isBad = isBad + 1;
                    inputData.data(channelCounter,:,epochCounter) = NaN;
                    
                end
                
            end
            
            if isBad == size(inputData,1)   % i.e., all channels have bad data for an epoch
                
                inputData.epoch(epochCounter) = [];
                checkCounter = checkCounter - 1;

                if isfield(inputData,'segmentMarkers') == 1
                    inputData.segmentMarkers(epochCounter,:) = [];
                end
                
            end
            
        end
        
    end

    inputData.channelArtifactPercentages = sum(removalMatrix,2)/numberOfEpochs*100;
    
    if checkCounter == 0 && optionFlag == 0
        disp('ALL TRIAL HAVE BEEN REMOVED!!!! Recommend interpolation or participant removal from analysis');
        badChannels = find(inputData.channelArtifactPercentages >= 100);
        disp('The following channels have too many artifacts:');
        inputData.chanlocs(badChannels).labels
        pause;
        return
    end
    
end
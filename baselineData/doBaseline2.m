function inputData = doBaseline2(inputData,baselinePoints)

    % written as a shell by Olav Krigolson for consitency
    % expects EEG in EEGLAB format and a baseline window in s [-.2 0]
    
    try
    
        tempData = inputData.data;

        for i = 1:size(tempData,3)

            for c = 1:size(tempData,1)

                trialData = squeeze(tempData(c,:,i));
                bData = trialData(1:baselinePoints);
                baseLine = mean(bData);
                trialData = trialData - baseLine;

                inputData.data(c,:,i) = trialData;

            end

        end
        
    catch
        
        %baselineWindow = baselineWindow / 1000;
        %inputData = pop_rmbase(inputData,baselineWindow);

        disp('FAIL');
        
    end

    inputData.baselineWindow = baselinePoints;
    
end
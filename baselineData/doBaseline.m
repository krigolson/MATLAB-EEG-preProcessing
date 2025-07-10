function inputData = doBaseline(inputData,baselineWindow)

    % written as a shell by Olav Krigolson for consitency
    % expects EEG in EEGLAB format and a baseline window in s [-200 0]
    
    try
    
        inputData = pop_rmbase(inputData,baselineWindow);
        
    catch
        
        %baselineWindow = baselineWindow / 1000;
        %inputData = pop_rmbase(inputData,baselineWindow);

        disp('FAIL');
        
    end

    inputData.baselineWindow = baselineWindow;
    
end
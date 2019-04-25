function inputData = doBaseline(inputData,baselineWindow)

    % written as a shell by Olav Krigolson for consitency
    % expects EEG in EEGLAB format and a baseline window in ms [-200 0]
    
    inputData = pop_rmbase(inputData,baselineWindow);
    inputData.baselineWindow = baselineWindow;
    
end
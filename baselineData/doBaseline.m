function inputData = doBaseline(inputData,baselineWindow)

    % written as a shell by Olav Krigolson for consitency
    % expects EEG in EEGLAB format and a baseline window in s [-200 0]

    % convert to seconds if needed
    if abs(baselineWindow(1)) < 10
        baselineWindow = baselineWindow * 1000;
    end
    
    inputData = pop_rmbase(inputData,baselineWindow);

    inputData.baselineWindow = baselineWindow;
    
end
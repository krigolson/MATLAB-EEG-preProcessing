function [inputData] = doInterpolate(inputData,chanlocs,method)

    % literally a shell to match our lab name calls, all credit to Marco Simoes
    % and the people who developed EEGLAB

    % note this function is EEGlab dependent
    
    [inputData] = interpol(inputData, chanlocs, method);
    
end
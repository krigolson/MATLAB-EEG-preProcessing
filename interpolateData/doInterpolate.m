function [inputData] = doInterpolate(inputData,chanlocs,method)

    % literally a shell to match our lab name calls, all credit to Marco Simoes
    % and the people who developed EEGLAB

    % note this function is EEGlab dependent
    inputData.interpolate = 1;
    inputData.interpolateChannelsPrior = size(inputData,1);
    inputData.interpolateChannels = inputData.chanlocs;    
    [inputData] = interpol(inputData, chanlocs);

end
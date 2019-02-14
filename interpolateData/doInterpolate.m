function [EEG] = doInterpolate(EEG,chanlocs,method)

% literally a shell to match our lab name calls, all credit to Marco Simoes
% and the people who developed EEGLAB

    [EEG] = interpol( EEG, chanlocs, method );
    
end
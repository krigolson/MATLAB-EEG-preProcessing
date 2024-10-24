function EEG = doFilterNotch(EEG,filterParameters)

    % currently expects an EEGLAB data structure

    %% Apply a bandpass filter
    %EEG = pop_eegfiltnew(EEG, [], filterParameters.low);
    
    %% 60 Hz Notch filter
    EEG = pop_eegfiltnew(EEG, filterParameters.notch-2, filterParameters.notch+2,[],1);

    %EEG.filterParameters = filterParameters;

end
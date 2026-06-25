function EEG = doFilterHigh(EEG,high)

    % Expects an EEGLAB data structure
    
    % Apply a bandpass filter
    EEG = pop_eegfiltnew(EEG, 'hicutoff', high);

    % save the filter parameters
    EEG.filterParameters.high = high;

end

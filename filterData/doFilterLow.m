function EEG = doFilterLow(EEG,low)

    % Expects an EEGLAB data structure
    
    % Apply a bandpass filter
    EEG = pop_eegfiltnew(EEG, 'locutoff', low);

    % save the filter parameters
    EEG.filterParameters.low = low;

end
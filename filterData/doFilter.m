function EEG = doFilter(EEG,filterParameters)

    % Expects an EEGLAB data structure

    % Apply a bandpass filter
    EEG = pop_eegfiltnew(EEG, filterParameters.low, filterParameters.high);

    % Apply a notch filter
    EEG = pop_eegfiltnew(EEG, filterParameters.notch-2, filterParameters.notch+2,[],1);

    % save the filter parameters
    EEG.filterParameters = filterParameters;

end

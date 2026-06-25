function EEG = doFilterBandPass(EEG,low,high)

    % Expects an EEGLAB data structure

    % Apply a bandpass filter
    EEG = pop_eegfiltnew(EEG, low, high);

    % save the filter parameters
    EEG.filterParameters.low = low;
    EEG.filterParameters.high = high;

end

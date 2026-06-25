function EEG = doFilterNotch(EEG,notch)

    % Expects an EEGLAB data structure
    
    % Apply a notch filter
    EEG = pop_eegfiltnew(EEG, notch-2, notch+2,[],1);

    % save the parameters
    EEG.filterParameters.notch = notch;

end

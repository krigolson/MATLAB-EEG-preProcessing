function EEG = doRereference(EEG,referenceChannels)

    % function to rereference EEG data
    EEG = pop_reref(EEG,referenceChannels);

end
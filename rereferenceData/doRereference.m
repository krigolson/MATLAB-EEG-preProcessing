function EEG = doRereference(EEG,referenceChannels,channelLocations)

    % function to rereference EEG data
    EEG = pop_reref(EEG,referenceChannels);

end
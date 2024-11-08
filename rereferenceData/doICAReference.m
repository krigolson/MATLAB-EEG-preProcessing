function EEG = doICAReference(EEG)

    % reref to average for ICA (recommended by Arnaud)
    EEG = pop_reref(EEG,[],'interpchan',[]);

end
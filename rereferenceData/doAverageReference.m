function EEG = doAverageReference(EEG)

    % create an average reference
    EEG = pop_reref(EEG,[]);

end
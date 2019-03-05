function [EEG] = doResample(EEG,newFrequency)

    % note, this is just an EEGLAB wrapper for consistency with the other
    % Krigolson Lab files and format
    
    EEG.resampleBefore = EEG.srate;
    EEG.resampleAfter = newFrequency;
    EEG = pop_resample(EEG,newFrequency);

end
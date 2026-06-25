function EEG = doInterpolateChannels(EEG, originalChanlocs)

    EEG.quality.interpolation.channelsBefore = EEG.nbchan;
    EEG.quality.interpolation.labelsBefore = {EEG.chanlocs.labels};

    % Interpolate missing/removed channels, including AFz if present in originalChanlocs
    EEG = eeg_interp(EEG, originalChanlocs, 'spherical');

    EEG.quality.interpolation.channelsAfter = EEG.nbchan;
    EEG.quality.interpolation.labelsAfter = {EEG.chanlocs.labels};
    EEG.quality.interpolation.numberInterpolated = ...
    EEG.quality.interpolation.channelsAfter - EEG.quality.interpolation.channelsBefore;

    EEG = eeg_checkset(EEG);

end

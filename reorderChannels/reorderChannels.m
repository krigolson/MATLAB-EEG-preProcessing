function EEG = reorderChannels(EEG,chanlocs)

if length(EEG.chanlocs) ~= length(chanlocs)
    disp('TWO FILES DO NOT HAVE THE SAME NUMBER OF CHANNELS');
    EEG.chanlocTest = 1;
else
    for i = 1:length(chanlocs)
        for o = 1:length(chanlocs)
            if strcmp(EEG.chanlocs(o).labels,chanlocs(i).labels)
                if ndims(EEG.data) == 2
                    tempData(i,:) = EEG.data(o,:);
                else
                    tempData(i,:,:) = EEG.data(o,:,:);
                end
                tempLabels(i) = EEG.chanlocs(o);
                break
            end
        end
    end
    EEG.data = tempData;
    EEG.chanlocs = tempLabels;
end
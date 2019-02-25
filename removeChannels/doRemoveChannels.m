function inputData = doEpochData(inputData,removeChannels,chanlocs)

    % by Olave Krigolson
    % function to remove EEG channels sent in as a list
    % removeChannels = {'TP9' 'TP10'}
    % added support so either an EEG lab structure or a channels x time
    % matrix can be submitted
    % input can be an EEGLAB EEG structure or just a channels x time data
    % matrix

    if size(removeChannels,2) ~= 0

        % adapt for EEGLAB structure or data matrix
        if isstruct(inputData)
            data = inputData.data;
            % keep track of history for analysis report
            inputData.removedChannels = removeChannels;
        else
            data = inputData;
        end

        % get a list of the channel names
        channelLabels = [];
        for i=1:length(chanlocs)
            channelLabels = [channelLabels {chanlocs(i).labels}];
        end

        % find the indicies of channels to remove
        numberOfChannelsToRemove = size(removeChannels,2);
        for channelCounter = 1:numberOfChannelsToRemove
            channelIndexToRemove(channelCounter) = find(strcmp(channelLabels,removeChannels{channelCounter}));
        end

        % sort the channels to be removed
        channelIndexToRemove = sort(channelIndexToRemove);
        
        % remove the channels
        removeCounter = numberOfChannelsToRemove;
        while 1
            disp('Removing Channel...');
            chanlocs(channelIndexToRemove(removeCounter)).labels
            data(channelIndexToRemove(removeCounter),:) = [];
            chanlocs(channelIndexToRemove(removeCounter)) = [];
            removeCounter = removeCounter - 1;
            if removeCounter == 0
                break
            end
        end
    
        % update the EEGLAB data structure and/or the data has been sent in
        if isstruct(inputData)
            inputData.data = [];
            inputData.data = data;
            inputData.nbchan = size(data,1);
            inputData.chanlocs = [];
            inputData.chanlocs = chanlocs;
            inputData.removedChannelsIndicies = channelIndexToRemove;
        else
            inputData = [];
            inputData = data;
        end
    
    disp('EEG channels have been removed...');
        
end
function inputData = doRereference(inputData,referenceChannels,chanlocs)

% function to rereference EEG data, supports a single channel reference, a two channel reference, or a mean
% reference
% reference channels should be supplied as follows
% {'TP9'} for a single reference
% {'TP9' 'TP10'} for a two channel reference
% {'AVERAGE'} for an average reference
% a valid channel location file must be supplied to detemine channel
% indicies

    % added support so either an EEG lab structure or a channels x time
    % matrix can be submitted
    if isstruct(inputData)
        data = inputData.data;
        % keep track of history for analysis report
        inputData.referenceChannels = referenceChannels;
    else
        data = inputData;
    end
    
    if strcmp(referenceChannels,'AVERAGE')
        
        % reference the data using the average of all channels
        referenceChannel = mean(data,1);

    else
        
        % get a list of the channel names
        channelLabels = [];
        for i=1:length(chanlocs)
            channelLabels = [channelLabels {chanlocs(i).labels}];
        end
        if size(referenceChannels,2) == 1
            referenceChannel1 = find(strcmp(channelLabels,referenceChannels{1}));
            referenceChannel = data(referenceChannel1,:); 
        else
            referenceChannel1 = find(strcmp(channelLabels,referenceChannels{1}));
            referenceChannel2 = find(strcmp(channelLabels,referenceChannels{2}));
            referenceChannel = (data(referenceChannel1,:) + data(referenceChannel2,:))/2;
        end

    end
    % subtract the reference channel from the data
    for channelCounter = 1:size(data,1)
        data(channelCounter,:) = data(channelCounter,:) - referenceChannel;
    end
    
    if isstruct(inputData)
        inputData.data = [];
        inputData.data = data;
    else
        inputData = [];
        inputData = data;
    end
    
    disp('EEG data has been rereferenced...');
        
end
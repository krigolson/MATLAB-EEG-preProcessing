function inputData = doChannelVariance(inputData,optionFlag)

    % function to compute channel variances by Olave Krigolson
    % optionFlag = 1 generates a plot, not recommended for batch
    % processing, this function requires an EEGLAB data structure with
    % channel locations
    
    channelMeans = mean(inputData.data,2);
    channelVariances = var(inputData.data,[],2);
    channelCIs = tinv(0.05,size(inputData.data,2))*std(inputData.data,[],2)/sqrt(size(inputData.data,2));
    
    if optionFlag ~= 0
        
        channelLabels = [];
        for i=1:length(inputData.chanlocs)
            channelLabels = [channelLabels {inputData.chanlocs(i).labels}];
        end
        
        figure;
        subplot(1,2,1);
        barwitherr(channelCIs,channelMeans);
        ylabel('Mean Voltage (uV)');
        xlabel('Channel');
        xticklabels(channelLabels);
        
        subplot(1,2,2);
        bar(channelVariances);
        ylabel('Voltage Variance (uV)');
        xlabel('Channel');
        xticklabels(channelLabels);
    end
    
    inputData.channelMeans = channelMeans;
    inputData.channelCIs = channelCIs;
    inputData.channelVariance = channelVariances;
        
end
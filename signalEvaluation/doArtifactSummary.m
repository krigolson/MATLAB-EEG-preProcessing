function doArtifactSummary(EEG)

% function to simply display artifact perfectage information

    bar(EEG.channelArtifactPercentages);
    ylim([0 100]);

    for counter = 1:size(EEG.chanlocs,2)
        chanNames{counter} = EEG.chanlocs(counter).labels;
    end

    set(gca,'xticklabels',chanNames);
    ylabel('Artifact %');
    xlabel('Channels');

end
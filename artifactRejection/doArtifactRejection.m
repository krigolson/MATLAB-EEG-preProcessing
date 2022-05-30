function EEG = doArtifactRejection(EEG,type,criteria)

    % written by Olav Krigolson
    % implements a variety of artifact rejection methods and removes bad
    % data trials if flagged
    % for now, only works for EEG format data that has been epoched (data
    % is channels x time x trials
    % also note, the assumption is a trial removal process that will use a
    % channels x trials matrix (the output of this)
    % supported types:
    % 'Gradient' - needs a single criteria value
    % 'Difference' - the difference in the max and min values
    % 'Max' - a maximum value check
    % 'Min' - a minimum value check
    % 'Variance - checks the variance of each epoch
    
    % to do
    % add time window
    
    artifactPresent = zeros(size(EEG.data,1),size(EEG.data,3));
    artifactSize = zeros(size(EEG.data,1),size(EEG.data,3));

    if strcmp('Gradient',type)
        
        % adjust criteria to make the value per sampling point
        criteria = criteria*1000/EEG.srate;

        for channelCounter = 1:size(EEG.data,1)

            for segmentCounter = 1:size(EEG.data,3)

                checkData = [];
                checkData = abs(diff(EEG.data(channelCounter,:,segmentCounter)));

                testDiff = max(checkData);

                if testDiff > criteria
                    artifactPresent(channelCounter,segmentCounter) = artifactPresent(channelCounter,segmentCounter) + 1;
                end

                artifactSize(channelCounter,segmentCounter) = artifactSize(channelCounter,segmentCounter) + testDiff;

            end

        end

    end
    if strcmp('Difference',type)

        for channelCounter = 1:size(EEG.data,1)

            for segmentCounter = 1:size(EEG.data,3)

                voltageMax = [];
                voltageMax = max(EEG.data(channelCounter,:,segmentCounter));

                voltageMin = [];
                voltageMin = min(EEG.data(channelCounter,:,segmentCounter));

                difference = abs(voltageMax - voltageMin);

                if difference > criteria
                    artifactPresent(channelCounter,segmentCounter) = artifactPresent(channelCounter,segmentCounter) + 1;
                end

                artifactSize(channelCounter,segmentCounter) = artifactSize(channelCounter,segmentCounter) + difference;

            end

        end

    end
    if strcmp('Max',type)

        for channelCounter = 1:size(EEG.data,1)

            for segmentCounter = 1:size(EEG.data,3)

                voltageMax = [];
                voltageMax = max(EEG.data(channelCounter,:,segmentCounter));

                if voltageMax > criteria
                    artifactPresent(channelCounter,segmentCounter) = artifactPresent(channelCounter,segmentCounter) + 1;
                end

                artifactSize(channelCounter,segmentCounter) = artifactSize(channelCounter,segmentCounter) + voltageMax;

            end

        end

    end
    if strcmp('Min',type)

        for channelCounter = 1:size(EEG.data,1)

            for segmentCounter = 1:size(EEG.data,3)

                voltageMin = [];
                voltageMin = min(EEG.data(channelCounter,:,segmentCounter));

                if voltageMin < criteria
                    artifactPresent(channelCounter,segmentCounter) = artifactPresent(channelCounter,segmentCounter) + 1;
                end

                artifactSize(channelCounter,segmentCounter) = artifactSize(channelCounter,segmentCounter) + voltageMin;

            end

        end

    end    
    if strcmp('Variance',type)

        for channelCounter = 1:size(EEG.data,1)

            for segmentCounter = 1:size(EEG.data,3)

                theVariance = [];
                theVariance = var(EEG.data(channelCounter,:,segmentCounter));

                if theVariance > criteria
                    artifactPresent(channelCounter,segmentCounter) = artifactPresent(channelCounter,segmentCounter) + 1;
                end

                artifactSize(channelCounter,segmentCounter) = artifactSize(channelCounter,segmentCounter) + theVariance;

            end

        end

    end

    if isfield(EEG,'artifact') == 0
        artPosition = 1;
    else
        artPosition = size(EEG.artifact,2)+1;
    end
    EEG.artifact(artPosition).type = type;
    EEG.artifact(artPosition).criteria = criteria;
    EEG.artifact(artPosition).badSegments = artifactPresent;
    EEG.artifact(artPosition).artifactSize = artifactSize;
    EEG.artifact(artPosition).artifactPercentages = (sum(EEG.artifact.badSegments,2)/size(EEG.artifact.badSegments,2))*100;
    
end
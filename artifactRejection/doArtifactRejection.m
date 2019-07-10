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
    
    if isfield(EEG,'artifactPresent') == 0
        EEG.artifactPresent = zeros(size(EEG.data,1),size(EEG.data,3));
    end
    % note, multiple calls of the artifact Size will make this variable
    % effectively useless
    if isfield(EEG,'artifactSize') == 0
        EEG.artifactSize = zeros(size(EEG.data,1),size(EEG.data,3));
    end
    if strcmp('Gradient',type)
        
        % adjust criteria to make the value per sampling point
        criteria = criteria*1000/EEG.srate;

        for channelCounter = 1:size(EEG.data,1)

            for segmentCounter = 1:size(EEG.data,3)

                checkData = [];
                checkData = abs(diff(EEG.data(channelCounter,:,segmentCounter)));

                testDiff = max(checkData);

                if testDiff > criteria
                    EEG.artifactPresent(channelCounter,segmentCounter) = EEG.artifactPresent(channelCounter,segmentCounter) + 1;
                end

                EEG.artifactSize(channelCounter,segmentCounter) = EEG.artifactSize(channelCounter,segmentCounter) + testDiff;

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
                    EEG.artifactPresent(channelCounter,segmentCounter) = EEG.artifactPresent(channelCounter,segmentCounter) + 1;
                end

                EEG.artifactSize(channelCounter,segmentCounter) = EEG.artifactSize(channelCounter,segmentCounter) + difference;

            end

        end

    end
    if strcmp('Max',type)

        for channelCounter = 1:size(EEG.data,1)

            for segmentCounter = 1:size(EEG.data,3)

                voltageMax = [];
                voltageMax = max(EEG.data(channelCounter,:,segmentCounter));

                if voltageMax > criteria
                    EEG.artifactPresent(channelCounter,segmentCounter) = EEG.artifactPresent(channelCounter,segmentCounter) + 1;
                end

                EEG.artifactSize(channelCounter,segmentCounter) = EEG.artifactSize(channelCounter,segmentCounter) + voltageMax;

            end

        end

    end
    if strcmp('Min',type)

        for channelCounter = 1:size(EEG.data,1)

            for segmentCounter = 1:size(EEG.data,3)

                voltageMin = [];
                voltageMin = min(EEG.data(channelCounter,:,segmentCounter));

                if voltageMin < criteria
                    EEG.artifactPresent(channelCounter,segmentCounter) = EEG.artifactPresent(channelCounter,segmentCounter) + 1;
                end

                EEG.artifactSize(channelCounter,segmentCounter) = EEG.artifactSize(channelCounter,segmentCounter) + voltageMin;

            end

        end

    end    
    if strcmp('Variance',type)

        for channelCounter = 1:size(EEG.data,1)

            for segmentCounter = 1:size(EEG.data,3)

                theVariance = [];
                theVariance = var(EEG.data(channelCounter,:,segmentCounter));

                if theVariance > criteria
                    EEG.artifactPresent(channelCounter,segmentCounter) = EEG.artifactPresent(channelCounter,segmentCounter) + 1;
                end

                EEG.artifactSize(channelCounter,segmentCounter) = EEG.artifactSize(channelCounter,segmentCounter) + theVariance;

            end

        end

    end

    if isfield(EEG,'artifactMethods') == 0
        EEG.artifactMethods{1} = type;
        EEG.artifactCriteria{1} = criteria;
    else
        EEG.artifactMethods{end+1} = type;
        EEG.artifactCriteria{end+1} = criteria;
    end
    
end
function inputData = doArtifactRejection(inputData,type,criteria)

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
    
    if isfield(inputData,'artifactPresent') == 0
        inputData.artifactPresent = zeros(size(inputData.data,1),size(inputData.data,3));
    end
    % note, multiple calls of the artifact Size will make this variable
    % effectively useless
    if isfield(inputData,'artifactSize') == 0
        inputData.artifactSize = zeros(size(inputData.data,1),size(inputData.data,3));
    end
    if strcmp('Gradient',type)

        for channelCounter = 1:size(inputData.data,1)

            for segmentCounter = 1:size(inputData.data,3)

                checkData = [];
                checkData = abs(diff(inputData.data(channelCounter,:,segmentCounter)));

                testDiff = max(checkData);

                if testDiff > criteria
                    inputData.artifactPresent(channelCounter,segmentCounter) = inputData.artifactPresent(channelCounter,segmentCounter) + 1;
                end

                inputData.artifactSize(channelCounter,segmentCounter) = inputData.artifactSize(channelCounter,segmentCounter) + testDiff;

            end

        end

    end
    if strcmp('Difference',type)

        for channelCounter = 1:size(inputData.data,1)

            for segmentCounter = 1:size(inputData.data,3)

                voltageMax = [];
                voltageMax = max(inputData.data(channelCounter,:,segmentCounter));

                voltageMin = [];
                voltageMin = min(inputData.data(channelCounter,:,segmentCounter));

                difference = abs(voltageMax - voltageMin);

                if difference > criteria
                    inputData.artifactPresent(channelCounter,segmentCounter) = inputData.artifactPresent(channelCounter,segmentCounter) + 1;
                end

                inputData.artifactSize(channelCounter,segmentCounter) = inputData.artifactSize(channelCounter,segmentCounter) + difference;

            end

        end

    end
    if strcmp('Max',type)

        for channelCounter = 1:size(inputData.data,1)

            for segmentCounter = 1:size(inputData.data,3)

                voltageMax = [];
                voltageMax = max(inputData.data(channelCounter,:,segmentCounter));

                if voltageMax > criteria
                    inputData.artifactPresent(channelCounter,segmentCounter) = inputData.artifactPresent(channelCounter,segmentCounter) + 1;
                end

                inputData.artifactSize(channelCounter,segmentCounter) = inputData.artifactSize(channelCounter,segmentCounter) + voltageMax;

            end

        end

    end
    if strcmp('Min',type)

        for channelCounter = 1:size(inputData.data,1)

            for segmentCounter = 1:size(inputData.data,3)

                voltageMin = [];
                voltageMin = min(inputData.data(channelCounter,:,segmentCounter));

                if voltageMin < criteria
                    inputData.artifactPresent(channelCounter,segmentCounter) = inputData.artifactPresent(channelCounter,segmentCounter) + 1;
                end

                inputData.artifactSize(channelCounter,segmentCounter) = inputData.artifactSize(channelCounter,segmentCounter) + voltageMin;

            end

        end

    end    
    if strcmp('Variance',type)

        for channelCounter = 1:size(inputData.data,1)

            for segmentCounter = 1:size(inputData.data,3)

                theVariance = [];
                theVariance = var(inputData.data(channelCounter,:,segmentCounter));

                if theVariance > criteria
                    inputData.artifactPresent(channelCounter,segmentCounter) = inputData.artifactPresent(channelCounter,segmentCounter) + 1;
                end

                inputData.artifactSize(channelCounter,segmentCounter) = inputData.artifactSize(channelCounter,segmentCounter) + theVariance;

            end

        end

    end

    if isfield(inputData,'artifactMethods') == 0
        inputData.artifactMethods{1} = type;
        inputData.artifactCriteria{1} = criteria;
    else
        inputData.artifactMethods{end+1} = type;
        inputData.artifactCriteria{end+1} = criteria;
    end
    
end
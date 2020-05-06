function rtOut = doExtractRT(inputData,startMarkers,responseMarkers)

    % function to extract RT data from EEGLAB markers
    % function looks for responseMarkers, e.g.,
    % responseMarkers = {'S301','S302','S303','S304'};
    % and then works back to look for the associated start markers, e.g.,
    % startMarkers = {'S4','S4','S4','S4'};
    % and returns an output variable that has the rt by trial and averaged
    % for each of the responseMarkers

    trialCounter = 1;

    for remarkerCounter = 1:length(startMarkers)

        goMarker = startMarkers{remarkerCounter};
        responseMarker = responseMarkers{remarkerCounter};

        for checkCounter = 1:size(inputData.event,2)

            % find the response marker
            if strcmp(inputData.event(checkCounter).type,responseMarker)

                endLatency = inputData.event(checkCounter).latency;

                % look back until the goMarker is found
                notFound = true;
                currentPosition = checkCounter-1;
                while notFound
                    if strcmp(inputData.event(currentPosition).type,goMarker)
                        startLatency = inputData.event(currentPosition).latency;
                        notFound = false;
                    end
                    currentPosition = currentPosition - 1;
                end

                rTs(trialCounter,1) = remarkerCounter;
                rTs(trialCounter,2) = endLatency - startLatency;
                rTs(trialCounter,3) = checkCounter;
                
                trialCounter = trialCounter + 1;
                
                % insert latency into event structure for future use
                inputData.event(checkCounter).rt = endLatency - startLatency;

            end

        end

    end
    
    % set up output variable
    for counter = 1:max(rTs(:,1))
        tempPos = [];
        tempPos = find(rTs(:,1) == counter);
        tempData = [];
        tempData = rTs(tempPos,2);
        meanData(1,counter) = mean(tempData);
        meanData(2,counter) = std(tempData);
        meanData(3,counter) = length(tempData);
        % CIs
        meanData(4,counter) = abs(tinv(0.025,length(tempData)) * std(tempData) / sqrt(length(tempData)));
    end
       
    rtOut.raw = rTs;
    rtOut.mean = meanData;
    rtOut.sorted = sortrows(rtOut.raw,3);
    
end
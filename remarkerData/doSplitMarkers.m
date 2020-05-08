function [EEG] = doSplitMarkers(EEG,targetMarkers,markerSplit,markerIncrement)

    numberOfMarkersToSplit = length(targetMarkers);
    EEG = doMarkerSummary(EEG);

    for markerCounter = 1:numberOfMarkersToSplit

        tempMarker = [];
        tempMarker = targetMarkers{markerCounter};
        tempStrip = [];
        tempStrip = strrep(tempMarker,' ','');
        tempStrip(1) = [];
        tempStrip = str2num(tempStrip);

        targetPositions = [];
        targetPositions = find(EEG.validMarkers == tempStrip);
        totalMarkers = length(targetPositions);

        % figure out add amounts
        chunkSize = round(totalMarkers*markerSplit);
        markerIncrements(1:totalMarkers) = 0;
        startPosition = chunkSize+1;
        currentJump = markerIncrement;
        chunkCounter = 1;
        while 1
            markerIncrements(startPosition) = currentJump;
            startPosition = startPosition + 1;
            chunkCounter = chunkCounter + 1;
            if chunkCounter > chunkSize
                currentJump = currentJump + markerIncrement;
                chunkCounter = 1;
            end
            if startPosition > totalMarkers
                break
            end
        end

        for checkCounter = 1:totalMarkers

            currentPosition = targetPositions(checkCounter);
            newMarker = tempStrip + markerIncrements(checkCounter);
            if newMarker < 10
                eventMarker = ['S  ' num2str(newMarker)];
            end
            if newMarker > 9 && newMarker < 100
                eventMarker = ['S ' num2str(newMarker)];
            end        
            if newMarker > 100
                eventMarker = ['S' num2str(newMarker)];
            end       
            EEG.event(currentPosition).type = eventMarker;

        end

    end

    EEG = doMarkerSummary(EEG);
    
end
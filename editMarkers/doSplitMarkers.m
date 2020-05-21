function [EEG] = doSplitMarkers(EEG,targetMarkers,markerSplit,markerIncrement)

    % by Olav Krigolson
    % this function allows you to split an existing markers into a series
    % of new markers that are incremented, for instance, to do a first half
    % second half comparison
    % targetMarkers are the markers to change
    % markerSplit is the percentage point to split, use 0.5 for a 50/50
    % split for instance
    % markerIncrement is how much to add to the marker each bin, make sure
    % this does not cause overlap! If this is 1, then 1 is added for each
    % new bin, etc

    numberOfMarkersToSplit = length(targetMarkers);
    
    % get a summary of all the markers which also creates numeric markers
    EEG = doMarkerSummary(EEG);

    % loop through the markers to split
    for markerCounter = 1:numberOfMarkersToSplit

        % get the first target marker
        tempMarker = [];
        tempMarker = targetMarkers{markerCounter};
        % strip it down to a number for simplicities sake
        tempStrip = [];
        tempStrip = strrep(tempMarker,' ','');
        tempStrip(1) = [];
        tempStrip = str2num(tempStrip);

        % find all the targets
        targetPositions = [];
        targetPositions = find(EEG.validMarkers == tempStrip);
        
        % figure out how many targets there are
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
            if ndims(EEG.data) == 2
                EEG.event(currentPosition).type = eventMarker;
            else
                EEG.epoch(currentPosition).eventtype = eventMarker;
            end

        end

    end

    EEG = doMarkerSummary(EEG);
    
end
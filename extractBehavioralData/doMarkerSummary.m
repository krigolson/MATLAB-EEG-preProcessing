function inputData = doMarkerSummary(inputData)

    % create a marker summary for an EEG data structure with all possible
    % markers and the counts

    validMarkers = [];
    validCounter = 1;

    for counter = 1:length(inputData.event)

        if strcmp(inputData.event(counter).type(1),'S')

            temp = [];
            temp = inputData.event(counter).type;
            temp = strrep(temp,' ','');
            temp(1) = [];
            validMarkers(validCounter) = str2num(temp);
            validCounter = validCounter + 1;

            % add marker as an integet to EEG.event
            inputData.event(counter).marker = str2num(temp);

        else
            
            inputData.event(counter).marker = 0;
            
        end

    end

    % first, lets do a marker count for all the markers present in the data
    possibleMarkers = unique(validMarkers);
    markerTable(1:2,1:length(possibleMarkers)) = 0;
    for currentMarker = 1:length(possibleMarkers)
        tempPositions = [];
        tempPositions = find(validMarkers == possibleMarkers(currentMarker));
        markerTable(1,currentMarker) = possibleMarkers(currentMarker);
        markerTable(2,currentMarker) = length(tempPositions);
    end
    
    inputData.markerTable = markerTable;
    inputData.validMarkers = validMarkers;
    
end
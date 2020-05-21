function EEG = doMarkerSummary(EEG)

    % create a marker summary for an EEG data structure with all possible
    % markers and the counts

    validMarkers = [];
    validCounter = 1;
    
    if ndims(EEG.data) == 2

        for counter = 1:length(EEG.event)

            if strcmp(EEG.event(counter).type(1),'S')

                temp = [];
                temp = EEG.event(counter).type;
                temp = strrep(temp,' ','');
                temp(1) = [];
                validMarkers(validCounter) = str2num(temp);
                validCounter = validCounter + 1;

                % add marker as an integet to EEG.event
                EEG.event(counter).marker = str2num(temp);

            else

                EEG.event(counter).marker = 0;

            end

        end
        
    end
    if ndims(EEG.data) == 3

        for counter = 1:length(EEG.epoch)

            if strcmp(EEG.epoch(counter).eventtype(1),'S')

                temp = [];
                temp = EEG.epoch(counter).eventtype;
                temp = strrep(temp,' ','');
                temp(1) = [];
                validMarkers(validCounter) = str2num(temp);
                validCounter = validCounter + 1;

                % add marker as an integet to EEG.epoch
                EEG.epoch(counter).marker = str2num(temp);

            else

                EEG.epoch(counter).marker = 0;

            end

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
    
    EEG.markerTable = markerTable;
    EEG.validMarkers = validMarkers;
    
end
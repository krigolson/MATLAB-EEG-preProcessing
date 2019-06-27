function EEG = doEditMarkers(EEG,currentMarkers,newMarkers)

    % written by Olav Krigolson
    % searches EEGLAB EEG structure for a marker and replaces it with new
    % values
    
    for markersToChange = 1:size(currentMarkers,2)
        targetMarker = currentMarkers{markersToChange};
        newMarker = newMarkers{markersToChange};
        for eventCounter = 1:size(EEG.event,2)
            if strcmp(EEG.event(eventCounter).type,targetMarker)
                EEG.event(eventCounter).type = newMarker;
            end
        end
    end
    
end
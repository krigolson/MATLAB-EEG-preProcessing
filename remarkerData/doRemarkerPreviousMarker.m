function inputData = doRemarkerPreviousMarker(inputData,firstMarkers,secondMarkers,newMarkers,n)

    % by Olave Krigolson
    % function to change a preceding marker behind n events into a new marker
    % based on another marker that is found. for example, say you want to
    % change your fixation markers that are all 1 into conditional values
    % based on feedback that occurs n events later
    % lets say you have a bunch of response markers that are all 6's and
    % 7's
    % responseMarkers = [6 6 6 6 7 7 7 7]
    % which are followed n markers later by feedback markers
    % feedbackMarkers = [201 202 203 204 201 202 203 204]
    % you pass in the first as firstMarkers, the second as secondMarkers,
    % and also a vector for the new values for the 6's and 7's
    % newMarkers = [301 302 303 304 301 302 303 304]
    % the n is literally how many positions before - negative values or how
    % many positions after - positive values, for instance if the markers
    % are S6 S4 and S201 then n = -2 using the example data above
    % sample call
    % EEG = doRemarkerPreviousMarker(EEG,{'S  6','S  6','S  6','S  6','S  7','S  7','S  7','S  7'},{'S201','S202','S203','S204','S201','S202','S203','S204'},{'S301','S302','S303','S304','S301','S302','S303','S304'},-2);
    
    for remarkerCounter = 1:length(firstMarkers)
   
        firstMarker = firstMarkers{remarkerCounter};
        targetMarker = secondMarkers{remarkerCounter};
        replaceMarker = newMarkers{remarkerCounter};
            
        for checkCounter = 1:size(inputData.event,2)
                
            if strcmp(inputData.event(checkCounter).type,targetMarker)
                
                modPosition = checkCounter + n;
                inputData.event(modPosition).type = replaceMarker;
                    
            end
                
        end
            
    end
        
end
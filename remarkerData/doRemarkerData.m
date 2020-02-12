function inputData = doRemarkerData(inputData,markerIn,markerOut)

    % by Olave Krigolson
    % function to change a marker into a new marker

    for remarkerCounter = 1:length(markerIn)
            
        for checkCounter = 1:size(inputData.event,2)
                
            if strcmp(inputData.event(checkCounter).type,markerIn{remarkerCounter})
                    
                inputData.event(checkCounter).type = markerOut{remarkerCounter};
                    
            end
                
        end
            
    end
        
end
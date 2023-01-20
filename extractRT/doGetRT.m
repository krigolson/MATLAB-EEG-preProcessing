function rt = doGetRT(EEG,markers)

% function to extract a vector of RT markers based on a stimulus and a
% response marker, always put the stimulus marker before the response
% marker, the response marker must be present for this to work

    i = 1;
    nEvents = size(EEG.event,2);
    rtCon = 1;
    rt = 0;

    while 1

        if strcmp(EEG.event(i).type,markers{1}) && strcmp(EEG.event(i+1).type,markers{2})
            currentRT = EEG.event(i+1).latency - EEG.event(i).latency;
            currentRT = currentRT * 1/EEG.srate*1000;
            rt(rtCon) = currentRT;
            rtCon = rtCon + 1;

        end

        i = i + 1;

        if i == nEvents

            break

        end

    end

end
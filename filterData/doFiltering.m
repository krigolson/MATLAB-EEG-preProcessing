function EEG = doFiltering(EEG,filterParameters)

    % add support for EEG lab data structure
    if isstruct(EEG)
        inData = EEG.data;
    else
        inData = EEG;
    end

    % ensure the data has double precision
    inData = double(inData);

    % use a high cutoff fitler
    [b,a] = butter(filterParameters.order,((filterParameters.high)/(filterParameters.srate/2)),'low');   % compute the filter parameters b and a
    for i = 1:size(inData,1)
        f1Data(i,:) = filtfilt(b,a,inData(i,:));
    end

    % use a low cutoff filter
    [b,a] = butter(filterParameters.order,((filterParameters.low)/(filterParameters.srate/2)),'high');   % compute the filter parameters b and a
    for i = 1:size(f1Data,1)
        f2Data(i,:) = filtfilt(b,a,f1Data(i,:));
    end

    % apply a notch filter at 60 Hz
    Qfactor = 35; % this is a suggested MATLAB parameter that makes the filter sharp
    wo = filterParameters.notch/(filterParameters.srate/2);  
    bw = wo/Qfactor;
    [b,a] = iirnotch(wo,bw);  
    for i = 1:size(f2Data,1)
        f3Data(i,:) = filtfilt(b,a,f2Data(i,:));
    end

    % add support for EEG lab data structure
    if isstruct(EEG)
        EEG.data = f3Data;
    else
        EEG = f3Data;
    end

end
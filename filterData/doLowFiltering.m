function EEG = doFiltering(EEG,filterParameters)

    % requires filter parameters in the following format
    % filterParameters.low = 0.1;
    % filterParameters.high = 30;
    % filterParameters.order = 1;
    % filterParameters.notch = 60;
    % filterParameters.srate = 500;

    % add support for EEG lab data structure
    if isstruct(EEG)
        inData = EEG.data;
    else
        inData = EEG;
    end

    % ensure the data has double precision
    inData = double(inData);

    % use a low cutoff filter
    [b,a] = butter(filterParameters.order,((filterParameters.low)/(filterParameters.srate/2)),'high');   % compute the filter parameters b and a
    for i = 1:size(f1Data,1)
        f2Data(i,:) = filtfilt(b,a,inData(i,:));
    end

    % add support for EEG lab data structure
    if isstruct(EEG)
        EEG.data = f2Data;
    else
        EEG = f2Data;
    end

end
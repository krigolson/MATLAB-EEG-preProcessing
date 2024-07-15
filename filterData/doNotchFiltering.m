function EEG = doNotchFiltering(EEG,filterParameters)

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

    % apply a notch filter at 60 Hz
    Qfactor = 35; % this is a suggested MATLAB parameter that makes the filter sharp
    wo = filterParameters.notch/(filterParameters.srate/2);  
    bw = wo/Qfactor;
    [b,a] = iirnotch(wo,bw);  
    for i = 1:size(f2Data,1)
        f3Data(i,:) = filtfilt(b,a,inData(i,:));
    end

    % add support for EEG lab data structure
    if isstruct(EEG)
        EEG.data = f3Data;
    else
        EEG = f3Data;
    end

end
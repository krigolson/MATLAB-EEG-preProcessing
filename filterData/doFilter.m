function [inputData] = doFilter(inputData,filterLow,filterHigh,filterOrder,filterNotch,samplingRate)

    % function doFilter to filter EEG data
    % by Olave Krigolson, January 29th, 2019
    % this function applies butter worth and notch filters to EEG data
    % the expected input is continuous EEG data in a channels x time format
    % you also need to specify the low pass and high pass values
    % (recommended 0.1 and 30), use 0 for no low pass or high pass
    % you can also specify the filter order for the Butterworth filter
    % (recommend 2)
    % you can also specify a notch filter, use 0 for no notch, to target
    % 50Hz or 60Hz line noise, note a Q factor of 35 is used
    % finally, the sampling rate of the EEG data is needed
    % sample call is 
    %eegData = doFilter(eegData,0.1,30,60,2,500);
    
    % add support for EEG lab data structure
    if isstruct(inputData)
        data = inputData.data;
        samplingRate = inputData.srate;
        % keep track of history for analysis report
        inputData.filterLow = filterLow;
        inputData.filterHigh = filterHigh;
        inputData.filterNotch = filterNotch;
        inputData.filterOrder = filterOrder;
    else
        data = inputData;
    end
    
    dataLength = size(data,2);
    numberOfChannels = size(data,1); % number of channels
    nyquistFrequency = 0.5*samplingRate; % half the sampling rate
    
    if filterLow ~= 0 & filterHigh == 0     % implement a low cuttoff filter
        [b,a] = butter(filterOrder,(filterLow/nyquistFrequency),'high');   % compute the filter parameters b and a
        for channelCounter = 1:numberOfChannels
            data(channelCounter,:) = filtfilt(b,a, data(channelCounter,:));
        end

    end        
    if filterLow == 0  & filterHigh ~= 0     % implement a high cuttoff filter
        [b,a] = butter(filterOrder,(filterHigh/nyquistFrequency),'low');   % compute the filter parameters b and a
        for channelCounter = 1:numberOfChannels
            data(channelCounter,:) = filtfilt(b,a, data(channelCounter,:));
        end

    end      
    if filterLow ~= 0  & filterHigh ~= 0     % implement a band pass filter
        [b,a] = butter(filterOrder,([filterLow filterHigh]/nyquistFrequency));   % compute the filter parameters b and a
        for channelCounter = 1:numberOfChannels
            data(channelCounter,:) = filtfilt(b,a,double(data(channelCounter,:)));
        end

    end  
    if filterNotch ~= 0     % do the notch filter
        Qfactor = 35; % need to learn more about what this does
        wo = filterNotch/nyquistFrequency;  
        bw = wo/Qfactor;
        [b,a] = iirnotch(wo,bw);
        for channelCounter = 1:numberOfChannels % filter data by channel and sample
            data(channelCounter,:) = filtfilt(b,a,double(data(channelCounter,:)));  
        end
    end
    
    if isstruct(inputData)
        inputData.data = [];
        inputData.data = data;
    else
        inputData = [];
        inputData = data;
    end

end
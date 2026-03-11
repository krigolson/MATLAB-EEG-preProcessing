function EEG = doCleanData(EEG)

    originalEEG = EEG;

    %count boundary events before cleaning
    initialBoundaries = 0;
    for i = 1:size(EEG.event,2)
        if strcmp(EEG.event(1,i).type,'boundary')
            initialBoundaries = initialBoundaries + 1;
        end
    end

    %Clean line noise from data with cleanline
    EEG = pop_cleanline(EEG, ...
      'SignalType','Channels', ...
      'ChanCompIndices',1:EEG.nbchan, ...
      'LineFrequencies',[60 120], ...
      'ScanForLines',true, ...
      'LineAlpha',0.01, ...
      'Bandwidth',2, ...
      'PlotFigures',false, ...
      'ComputeSpectralPower',false, ...
      'VerbosityLevel',0);
    
    % count boundary events due to cleanline
    lineBoundaries = 0;
    for i = 1:size(EEG.event,2)
        if strcmp(EEG.event(1,i).type,'boundary')
            lineBoundaries = lineBoundaries + 1;
        end
    end


    % Here is the real magic: identify bad channels, remove them, and clean momentary artifacts with clean_raw_data
    %[EEG] = pop_clean_rawdata(EEG,'Bandwidth',2,'ChanCompIndices',1:EEG.nbchan,'SignalType','Channels','ComputeSpectralPower',true,'LineFrequencies',[60 120] ,'NormalizeSpectrum',false,'LineAlpha',0.01,'PaddingFactor',2,'PlotFigures',false,'ScanForLines',true,'SmoothingFactor',100,'VerbosityLevel',1,'SlidingWinLength',EEG.pnts/EEG.srate,'SlidingWinStep',EEG.pnts/EEG.srate);
    
    % Arnaud's version
    EEG = pop_clean_rawdata(EEG,'FlatlineCriterion',5,'ChannelCriterion',0.7,'LineNoiseCriterion',4,'BurstCriterion',20,'WindowCriterion',0.25,'BurstRejection','on','Distance','Euclidian','WindowCriterionTolerances',[-Inf 7] ,'fusechanrej',1);

    %count boundary events due to clean raw data
    rawBoundaries = 0;
    for i = 1:size(EEG.event,2)
        if strcmp(EEG.event(1,i).type,'boundary')
            rawBoundaries = rawBoundaries + 1;
        end
    end

    % get some useful output about what clean raw data actually did
    EEG.quality.cleanraw.percentOfDataRemoved = (size(originalEEG.data,2) - size(EEG.data,2))/size(originalEEG.data,2)*100;
    EEG.quality.cleanraw.numberOfChannelsRemoved = size(originalEEG.data,1) - size(EEG.data,1);
    EEG.quality.cleanraw.initialBoundaryEvents = initialBoundaries;
    EEG.quality.cleanraw.cleanlineBoundaryEvents = lineBoundaries;
    EEG.quality.cleanraw.cleanrawBoundaryEvents = rawBoundaries;

end
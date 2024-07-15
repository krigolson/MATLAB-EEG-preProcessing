function EEG = doCleanData(EEG)

    [EEG] = pop_cleanline(EEG); %Clean line noise from data with cleanline
    
    % Here is the real magic: identify bad channels, remove them, and clean momentary artifacts with clean_raw_data
    [EEG] = pop_clean_rawdata(EEG,'Bandwidth',2,'ChanCompIndices',1:EEG.nbchan,'SignalType','Channels','ComputeSpectralPower',true,'LineFrequencies',[60 120] ,'NormalizeSpectrum',false,'LineAlpha',0.01,'PaddingFactor',2,'PlotFigures',false,'ScanForLines',true,'SmoothingFactor',100,'VerbosityLevel',1,'SlidingWinLength',EEG.pnts/EEG.srate,'SlidingWinStep',EEG.pnts/EEG.srate);

end
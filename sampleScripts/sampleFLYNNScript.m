clear all;
close all;
clc;

cd('/Users/olavekrigolson/Data/New CogAssess Tutorial Data/Oddball');

fileNames = dir('*.vhdr');

for fileCounter = 1:length(fileNames)
    
    % get the current filename
    currentFileName = fileNames(fileCounter).name;
    
    disp('Now analyzing...');
    currentFileName

    [EEG] = [];
    [FFT] = [];
    [WAV] = [];
    [EEG] = doLoadBVData(currentFileName);
    
    % correct a small problem in terms of marker naming...
    for markerCounter = 1:length(EEG.event)
        if length(EEG.event(markerCounter).type) > 4
            EEG.event(markerCounter).type(2) = [];
        end
    end

    % strip the .vhdr from the end
    currentFileName(end-4:end) = [];
    
    % put the fileName into the EEG data structure
    EEG.fileName = currentFileName;

    [EEG] = doResample(EEG,250);

    % if needed
    %[EEG] = doRemoveChannels(EEG,{},EEG.chanlocs);
        
    % if needed
    %[EEG] = doInterpolate(EEG,EEG.chanlocs,'spherical');

    % fix one bad channel for participant 25
    if fileCounter == 25
        chanlocs = EEG.chanlocs;
        [EEG] = doRemoveChannels(EEG,{'AF4'},EEG.chanlocs);
        [EEG] = doInterpolate(EEG,chanlocs,'spherical');
    end
    % fix one bad channel for participant 28
    if fileCounter == 28
        chanlocs = EEG.chanlocs;
        [EEG] = doRemoveChannels(EEG,{'C1'},EEG.chanlocs);
        [EEG] = doInterpolate(EEG,chanlocs,'spherical');
    end
    % fix two bad channels for participant 29
    if fileCounter == 29
        chanlocs = EEG.chanlocs;
        [EEG] = doRemoveChannels(EEG,{'C1','PO4'},EEG.chanlocs);
        [EEG] = doInterpolate(EEG,chanlocs,'spherical');
    end

    if fileCounter == 30
        chanlocs = EEG.chanlocs;
        [EEG] = doRemoveChannels(EEG,{'Fp1','T8'},EEG.chanlocs);
        [EEG] = doInterpolate(EEG,chanlocs,'spherical');
    end
        
    [EEG] = doRereference(EEG,{'TP9','TP10'},EEG.chanlocs);

    [EEG] = doFilter(EEG,0.1,30,60,2,500);

    [EEG] = doEpochData(EEG,{'S202','S203'},[-500 1500]);

    [EEG] = doBaseline(EEG,[-200,0]);

    [EEG] = doArtifactRejection(EEG,'Gradient',30);
    [EEG] = doArtifactRejection(EEG,'Difference',150);

    [EEG] = doRemoveEpochs(EEG,EEG.artifactPresent);

    [ERP] = doERP(EEG,{'S202','S203'});

    [FFT] = doFFT(EEG,{'S202','S203'});

    [WAV] = doWAV(EEG,{'S202','S203'},[-500 -300],1,30,60,6);
    
    % a Krigolson Lab legacy joke in terms of the name, create a variable to store all the data
    DISC.EEG = EEG;
    DISC.ERP = ERP;
    DISC.FFT = FFT;
    DISC.WAV = WAV;
    
    save(currentFileName,'DISC');
    
end
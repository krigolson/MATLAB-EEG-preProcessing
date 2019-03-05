clear all;
close all;
clc;

cd('/Users/olavekrigolson/Data/New CogAssess Tutorial Data/Oddball');

fileNames = dir('*.mat');

for fileCounter = 1:length(fileNames)
    
    clc;
    
    % get the current filename
    currentFileName = fileNames(fileCounter).name;
    
    disp('Now analyzing...');
    currentFileName
    
    load(currentFileName);
    
    STUDY.ERP.data(:,:,:,fileCounter) = DISC.ERP.data;
    STUDY.ERP.epochs(fileCounter,1) = DISC.ERP.totalEpochs;
    STUDY.ERP.epochs(fileCounter,2) = DISC.ERP.epochCount(1);
    STUDY.ERP.epochs(fileCounter,3) = DISC.ERP.epochCount(2);
    STUDY.ERP.chanlocs{fileCounter} = DISC.ERP.chanlocs;
    STUDY.ERP.samplingRate(fileCounter) = DISC.ERP.srate;
    STUDY.ERP.epochTime(fileCounter,1) = DISC.ERP.epochTime(1);
    STUDY.ERP.epochTime(fileCounter,2) = DISC.ERP.epochTime(2);
    STUDY.ERP.times(:,fileCounter) = DISC.ERP.times;
    STUDY.ERP.preprocessing(fileCounter,1) = DISC.EEG.filterLow;
    STUDY.ERP.preprocessing(fileCounter,2) = DISC.EEG.filterHigh;
    STUDY.ERP.preprocessing(fileCounter,3) = DISC.EEG.filterOrder;
    STUDY.ERP.preprocessing(fileCounter,4) = DISC.EEG.filterNotch;
    STUDY.ERP.preprocessing(fileCounter,5) = DISC.EEG.epochTimes(1);
    STUDY.ERP.preprocessing(fileCounter,6) = DISC.EEG.epochTimes(2);
    STUDY.ERP.preprocessing(fileCounter,7) = DISC.EEG.baselineWindow(1);
    STUDY.ERP.preprocessing(fileCounter,8) = DISC.EEG.baselineWindow(2);
    STUDY.ERP.preprocessing(fileCounter,9) = DISC.EEG.artifactCriteria{1};
    STUDY.ERP.preprocessing(fileCounter,10) = DISC.EEG.artifactCriteria{2};
    STUDY.ERP.epochMarker(fileCounter).markers = DISC.EEG.epochMarkers;
    STUDY.ERP.artifactMethods{fileCounter} = DISC.EEG.artifactMethods;
    STUDY.ERP.artifactPercentages(fileCounter,:) = DISC.EEG.channelArtifactPercentages;
    
end

times = STUDY.ERP.times(:,1);
erps = STUDY.ERP.data;
granderps = mean(erps,4);
dwerps = erps(:,:,1,:) - erps(:,:,2,:);
granddwerps = mean(dwerps,4);

subplot(1,2,1);
plot(times,granderps(52,:,1));
hold on;
plot(times,granderps(52,:,2));
hold off;
title('Condition Waveforms');
xlabel('Time (ms)');
ylabel('Voltage (uV)');
subplot(1,2,2);
plot(times,granddwerps(52,:,1));
title('Difference Waveform');
xlabel('Time (ms)');
ylabel('Voltage (uV)');

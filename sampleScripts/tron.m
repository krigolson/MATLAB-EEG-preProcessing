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

    STUDY.FFT.data(:,:,:,fileCounter) = DISC.FFT.data;
    STUDY.FFT.frequencies(fileCounter,:) = DISC.FFT.frequencies;

    STUDY.WAV.data(:,:,:,:,fileCounter) = DISC.WAV.data;
    STUDY.WAV.percent(:,:,:,:,fileCounter) = DISC.WAV.percent;
    STUDY.WAV.frequencies(fileCounter,:) = DISC.WAV.frequencies;
    STUDY.WAV.preprocessing(fileCounter,1) = DISC.WAV.frequencyRange(1);
    STUDY.WAV.preprocessing(fileCounter,2) = DISC.WAV.frequencyRange(2);
    STUDY.WAV.preprocessing(fileCounter,3) = DISC.WAV.frequencySteps;
    STUDY.WAV.preprocessing(fileCounter,4) = DISC.WAV.mortletParameter;
    STUDY.WAV.preprocessing(fileCounter,5) = DISC.WAV.baseline(1);
    STUDY.WAV.preprocessing(fileCounter,6) = DISC.WAV.baseline(2);

end

channel = 52;
chanlocs = STUDY.ERP.chanlocs{1};

% averaging
times = STUDY.ERP.times(:,1);
erps = STUDY.ERP.data;
granderps = mean(erps,4);
dwerps = erps(:,:,1,:) - erps(:,:,2,:);
granddwerps = mean(dwerps,4);

% plots
figure(1);
subplot(3,1,1);
plot(times,granderps(channel,:,1));
hold on;
plot(times,granderps(channel,:,2));
hold off;
title('Condition Waveforms');
xlabel('Time (ms)');
ylabel('Voltage (uV)');
subplot(3,1,2);
plot(times,granddwerps(channel,:,1));
title('Difference Waveform');
xlabel('Time (ms)');
ylabel('Voltage (uV)');

[maxValue maxPosition] = max(granddwerps(channel,:));

[maxp300Peaks maxp300Times maxP300Topos] = maxPeakDetection(dwerps,times,channel,times(maxPosition),100);

[meanp300Peaks meanp300Times meanP300Topos] = meanPeakDetection(dwerps,times,channel,times(maxPosition),10);

subplot(3,1,3);
topoData = mean(maxP300Topos,2);
topoplot(topoData,chanlocs, 'verbose','off','style','fill','numcontour',8);

figure(2);
channel = 52;
frequencies = STUDY.FFT.frequencies(1,:);
fftdata = STUDY.FFT.data;
meanfftdata = mean(fftdata,4);
dwfftdata = fftdata(:,:,1,:) - fftdata(:,:,2,:);
meandwfftdata = mean(dwfftdata,4);
subplot(1,3,1);
plot(frequencies(1:60),meanfftdata(channel,1:60,1));
hold on;
plot(frequencies(1:60),meanfftdata(channel,1:60,2));
hold off;
subplot(1,3,2);
plot(frequencies(1:60),meandwfftdata(channel,1:60,1));

[fftPower freqtopo] = frequencyExtraction(dwfftdata,frequencies,channel,[4 7]);

subplot(1,3,3);
meanfreqtopo = mean(freqtopo,2);
topoplot(meanfreqtopo,chanlocs, 'verbose','off','style','fill','numcontour',8);

[tresult presult cresult] = wavAnalysis(STUDY.WAV.data,34,[1 2],60,500,1000,0.2);
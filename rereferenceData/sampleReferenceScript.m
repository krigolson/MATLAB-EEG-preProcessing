% sample call to doRereference

clear all;
close all;
clc;

load('sampleEEGData.mat');

channelToPlot = 1;
amountOfDataToPlot = 500;
referenceChannels = {'TP9' 'TP10'};

% filter the data to remove the offsets
EEG = doFilter(EEG,struct('low',0.5,'high',30,'notch',60));

% get some data to plot from before the rereference
preRereferenceData = squeeze(EEG.data(channelToPlot,1:amountOfDataToPlot));

% rereference the data
EEG = doRereference(EEG,referenceChannels);

% get some data to plot post filter
postRereferenceData = EEG.data(channelToPlot,1:amountOfDataToPlot);

% plot some stuff
plot([1:1:amountOfDataToPlot],preRereferenceData,'linewidth',3);
hold on;
plot([1:1:amountOfDataToPlot],postRereferenceData,'linewidth',3);
hold off; 
clear all;
close all;
clc;

load('sampleEEGData.mat');
samplingRate = EEG.srate;           % the sampling rate of the data
filterOrder = 4;                    % the filter order
lowCutoff = 0.1;                    % a specified low pass value
highCutoff = 30;                    % a specified high pass value
notchFilter = 0;                   % a specified notch filter value
amountOfDataToPlot = 500;           % the amount of data to plot for comparison, has no impact on the actual filtering

% get some data to plot from before the filter
preFilterData = squeeze(EEG.data(1,1:amountOfDataToPlot));
% demean the data for comparison with the filtered data as the filter will adjust the mean of the data
preFilterData = preFilterData - mean(preFilterData);

% filter the data with a band pass filter
EEG.data = doFilter(EEG.data,lowCutoff,highCutoff,notchFilter,filterOrder,samplingRate);

% get some data to plot post filter
postFilterData = EEG.data(1,1:amountOfDataToPlot);

% plot some stuff
plot([1:1:amountOfDataToPlot],preFilterData,'linewidth',3);
hold on;
plot([1:1:amountOfDataToPlot],postFilterData,'linewidth',3);
hold off;
title('Pre versus Post Filter Data');
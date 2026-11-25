clear all;
close all;
clc;

load('sampleEEGData.mat');
lowCutoff = 0.5;                    % a specified low pass value
highCutoff = 30;                    % a specified high pass value
amountOfDataToPlot = 500;           % the amount of data to plot for comparison, has no impact on the actual filtering

% get some data to plot from before the filter
preFilterData = squeeze(EEG.data(1,1:amountOfDataToPlot));
% demean the data for comparison with the filtered data as the filter will adjust the mean of the data
preFilterData = preFilterData - mean(preFilterData);

% filter the data with a band pass filter
EEG = doFilterBandPass(EEG,lowCutoff,highCutoff);

% get some data to plot post filter
postFilterData = EEG.data(1,1:amountOfDataToPlot);

% plot some stuff
plot([1:1:amountOfDataToPlot],preFilterData,'linewidth',3);
hold on;
plot([1:1:amountOfDataToPlot],postFilterData,'linewidth',3);
hold off;
title('Pre versus Post Filter Data');
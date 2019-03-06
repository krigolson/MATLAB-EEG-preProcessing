%%% another filter demonstration by Olave E. Krigolson to demonstrate how
%%% MATLAB actually implements a dual pass Butterworth filter
%%% this one assumes there is a raw EEG data in an EEGLAB data structure
%%% use "loadBVData" to load some of the provided sample data

clear all;
close all;
clc;

% load the sample data set
load('sampleEEGData.mat');

% grab the first 1000 data points of channel 1
sampleData = squeeze(EEG.data(1,1:1000));

% grab the sampling rate of the data
samplingRate = EEG.srate;

% determine the length of the data sample
dataLength = length(sampleData);

% compute the Nyquist frequency which is half the sampling rate
nyquistFrequency = 0.5*samplingRate; 

% set some filter parameters
filterRange = [50 100];             % these are the low pass and high pass filter values
filterOrder = 15;                    % this is the filter order - see Luck, 2015 for more detail

% construct the filter
[b,a] = butter(filterOrder,([filterRange(1) filterRange(2)]/nyquistFrequency));   % compute the filter parameters b and a

% implement a dual pass (forward and backwards) filter to avoid phase
% shifts, note we force the data to be dual precision (see MATLAB help) to
% ensure the filtfilt comand works (data has to be dual precision)
filteredData = filtfilt(b,a,double(sampleData));

% plot the results
timePoints = [1:1:1000];
% note, we have to remove the mean from the original data as it will be
% offset - the filter will automatically remove the mean as a result of
% filtering
sampleData = sampleData - mean(sampleData);
subplot(1,2,1);
plot(timePoints,sampleData);
hold on
plot(timePoints,filteredData,'LineWidth',3);

subplot(1,2,2);
% get the filter information to show the cuttoff
[magnitude frequencies] = freqz(b,a,512,samplingRate);
plot(frequencies,abs(magnitude));
title('Filter Frequency Response');
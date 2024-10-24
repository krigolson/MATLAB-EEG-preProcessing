%%% this filter assumes you have the tutorial data

clear;
close all;
clc;

pathName = '/Users/krigolson/Desktop/tutorialData';
fileName = 'Oddball1.vhdr';

EEG = doLoadBVData(pathName,fileName);

% the range of data points you have
dataRange = [1 2000];

% preserve the original EEG data
originalEEG = EEG;

% plot the raw data
subplot(4,1,1);
plot(originalEEG.data(1,dataRange(1):dataRange(2)));
title('Raw Data');

% bandpass 0.5 to 30 Hz
filterParameters.low = 0.5;
filterParameters.high = 30;
filterParameters.notch = 60;
EEG1 = doFilter(originalEEG,filterParameters);
subplot(4,1,2);
plot(EEG1.data(1,dataRange(1):dataRange(2)));
title('BandPass 0.5 to 30 Hz');

% bandpass 0.1 to 1 Hz
filterParameters.low = 0.1;
filterParameters.high = 1;
filterParameters.notch = 60;
EEG2 = doFilter(originalEEG,filterParameters);
subplot(4,1,3);
plot(EEG2.data(1,dataRange(1):dataRange(2)));
title('BandPass 0.1 to 1 Hz');

% bandpass 0.1 to 1 Hz
filterParameters.low = 70;
filterParameters.high = 100;
filterParameters.notch = 60;
EEG3 = doFilter(originalEEG,filterParameters);
subplot(4,1,4);
plot(EEG3.data(1,dataRange(1):dataRange(2)));
title('BandPass 70 to 100 Hz');


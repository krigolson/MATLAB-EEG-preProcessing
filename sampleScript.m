% preprocessing revised
% olav and matt June 25, 2026

% clear memory, close windows, clear command prompt
clear;
close all;
clc;

% specify where the file is and its name
pathName = '/Users/krigolson/Desktop/Mats Playground/Test Data/Raw';
fileName = 'Ownership_001.vhdr';

% load the appropriate channel locations
load('channelLocations64.mat');

% load some data
EEG = doLoadBVData(pathName,fileName);

% filter data
lowCutoff = 0.5;
highCutoff = 30;
EEG = doFilterBandPass(EEG,lowCutoff,highCutoff);

% clean the data prior to ICA to remove noise
EEG = doCleanRawData(EEG);

% rereference data, necessary for ICA
EEG = doAverageReference(EEG);

% run the ICA
EEG = doICA(EEG);

% use ICLabel to remove artifacts
EEG = doICLabel(EEG);

% interpolate channels removed by clean_rawdata
EEG = doInterpolateChannels(EEG, chanLocs64);
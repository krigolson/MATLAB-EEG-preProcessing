clear all;
close all;
clc;

% load data missing channel 10, C6
load('sampleMissingChannelData.mat');
% load a complete chanlocs file
load('chanlocs.mat');

disp('The current number of channels is: ');
size(EEG.data,1)

% interpolate the missing channel using the method of spherical splines
[EEG] = doInterpolate(EEG,chanlocs,'spherical');

disp('The new number of channels is: ');
size(EEG.data,1)
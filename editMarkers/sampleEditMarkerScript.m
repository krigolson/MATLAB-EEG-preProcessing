clear all;
close all;
clc;

EEG = doLoadPEER('testEditMarkerData',{'100','101','200','201'});

EEG = doEditMarkers(EEG,{'100','101','200','201'},{'7','7','8','8'});
clear all;
close all;
clc;

[EEG] = doLoadBVData('Cognitive_Assessment_01.vhdr');

doRawDataInspection(EEG);
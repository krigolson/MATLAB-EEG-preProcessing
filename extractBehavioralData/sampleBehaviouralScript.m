clear all;
close all;
clc;

EEG = doLoadBVData();

EEG = doRemarkerPreviousMarker(EEG,{'S  6','S  6','S  6','S  6','S  7','S  7','S  7','S  7'},{'S101','S102','S103','S104','S101','S102','S103','S104'},{'S301','S302','S302','S301','S301','S302','S302','S301'},-2);
EEG = doRemarkerPreviousMarker(EEG,{'S  6','S  6','S  6','S  6','S  7','S  7','S  7','S  7'},{'S201','S202','S203','S204','S201','S202','S203','S204'},{'S401','S402','S402','S401','S401','S402','S402','S401'},-2);

EEG = doMarkerSummary(EEG);

rtOut = doExtractRT(EEG,{'S  4','S  4','S  4','S  4'},{'S301','S302','S401','S402'});
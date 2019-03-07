clear all;
close all;
clc;

load('samplePCAData.mat');

%[PCAResults TSPCAResults] = temporalSpatialPCA(ERP.data,ERP.chanlocs,ERP.time,'PMAX','IMAX',5);

[PCAResults STPCAResults] = spatialTemporalPCA(ERP.data,ERP.chanlocs,ERP.time,'PMAX','IMAX',5);
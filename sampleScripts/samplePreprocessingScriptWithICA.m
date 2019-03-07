clear all;
close all;
clc;

[EEG] = doLoadBVData('Cognitive_Assessment_01.vhdr');

% not needed but here for demonstration purposes
%[EEG] = doRemoveChannels(EEG,{},EEG.chanlocs);

% not needed but here for demonstration purposes
%[EEG] = doInterpolate(EEG,EEG.chanlocs,'spherical');

[EEG] = doRereference(EEG,{'TP9','TP10'},EEG.chanlocs);

[EEG] = doFilter(EEG,0.1,30,60,2,500);

[EEG] = doICA(EEG,0);
doICAPlotComponents(EEG,25);
doICAPlotComponentLoadings(EEG,16,[1001 2000]);
componentsToRemove = [];

[EEG] = doICARemoveComponents(EEG,componentsToRemove);

[EEG] = doEpochData(EEG,{'S202','S203'},[-200 800]);

[EEG] = doBaseline(EEG,[-200,0]);

[EEG] = doArtifactRejection(EEG,'Gradient',30);
[EEG] = doArtifactRejection(EEG,'Difference',150);

[EEG] = doRemoveEpochs(EEG,EEG.artifactPresent);

[ERP] = doERP(EEG,{'S202','S203'});

% plot the results, a P300 on Channel 52 (Pz)
figure;
plot(ERP.times,ERP.data(52,:,1),'LineWidth',3);
hold on;
plot(ERP.times,ERP.data(52,:,2),'LineWidth',3);
hold off;
title('Channel Pz');
ylabel('Voltage (uV)');
xlabel('Time (ms)');

clear all;
close all;
clc;

[EEG] = doLoadBVData('Cognitive_Assessment_01.vhdr');

[EEG] = doRereference(EEG,{'TP9','TP10'},'ALL',EEG.chanlocs);

[EEG] = doFilter(EEG,0.1,30,2,60,500);

[EEG] = doEpochData(EEG,{'S202','S203'},[-200 800]);

[EEG] = doBaseline(EEG,[-200,0]);

[EEG] = doArtifactRejection(EEG,'Gradient',10);
[EEG] = doArtifactRejection(EEG,'Difference',150);

[EEG] = doRemoveEpochs(EEG,EEG.artifactPresent,0);

[ERP] = doERP(EEG,{'S202','S203'});

% plot the results, a P300 on Channel 52 (Pz)
plot(ERP.times,ERP.data(52,:,1),'LineWidth',3);
hold on;
plot(ERP.times,ERP.data(52,:,2),'LineWidth',3);
hold off;
title('Channel Pz');
ylabel('Voltage (uV)');
xlabel('Time (ms)');
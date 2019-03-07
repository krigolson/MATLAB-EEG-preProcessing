clear all;
close all;
clc;

[EEG] = doLoadBVData('Cognitive_Assessment_03.vhdr');

[EEG] = doRereference(EEG,{'TP9','TP10'},EEG.chanlocs);

[EEG] = doFilter(EEG,0.1,30,60,2,500);

[EEG] = doEpochData(EEG,{'S202','S203'},[-200 800]);

preOcularEEG1 = EEG.data(35,:,60);
preOcularEEG2 = EEG.data(1,:,60);

[EEG] = doOcularCorrection(EEG,{'S202','S203'},{'Fp1'});

postOcularEEG1 = EEG.data(35,:,60);
postOcularEEG2 = EEG.data(1,:,60);

[EEG] = doBaseline(EEG,[-200,0]);

[EEG] = doArtifactRejection(EEG,'Gradient',30);
[EEG] = doArtifactRejection(EEG,'Difference',150);

[EEG] = doRemoveEpochs(EEG,EEG.artifactPresent);

[ERP] = doERP(EEG,{'S202','S203'});

% plot the results, a P300 on Channel 52 (Pz)
subplot(1,2,1);
plot(ERP.times,preOcularEEG1,'LineWidth',3);
hold on;
plot(ERP.times,postOcularEEG1,'LineWidth',3);
hold off;
title('Channel FPz: Comparison of Pre and Post Ocular EEG');
ylabel('Voltage (uV)');
xlabel('Time (ms)');

subplot(1,2,2);
plot(ERP.times,preOcularEEG2,'LineWidth',3);
hold on;
plot(ERP.times,postOcularEEG2,'LineWidth',3);
hold off;
title('Channel AF3: Comparison of Pre and Post Ocular EEG');
ylabel('Voltage (uV)');
xlabel('Time (ms)');
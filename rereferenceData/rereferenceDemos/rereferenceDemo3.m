clear all
close all

% recovery of data that has been referenced out

y = 1:0.1:12;
y = sin(y);
signal = y(40:99);
signal = signal * 10;

r1 = 1 + 2.*randn(200,1);
r2 = 1 + 2.*randn(200,1);
r3 = 1 + 2.*randn(200,1);
r4 = 1 + 2.*randn(200,1);
r5 = 1 + 2.*randn(200,1);
r6 = 1 + 2.*randn(200,1);

r1(70:129) = r1(70:129) + signal';

span = 10; % Size of the averaging window
window = ones(span,1)/span; 
r1 = filter(window,1,r1);
r2 = filter(window,1,r2);
r3 = filter(window,1,r3);
r4 = filter(window,1,r4);
r5 = filter(window,1,r5);
r6 = filter(window,1,r6);

figure

subplot(2,3,1),plot(r1,'b');
title('Channel 1');
axis([0 200 -15 15]);
subplot(2,3,2),plot(r2,'b');
title('Channel 2');
axis([0 200 -15 15]);
subplot(2,3,3),plot(r3,'b');
title('Channel 3');
axis([0 200 -15 15]);
subplot(2,3,4),plot(r4,'b');
title('Channel 4');
axis([0 200 -15 15]);
subplot(2,3,5),plot(r5,'b');
title('Channel 5');
axis([0 200 -15 15]);
subplot(2,3,6),plot(r6,'b');
title('Channel 6');
axis([0 200 -15 15]);

suplabel('Raw  Data','t');

pause

% Referenced Data

figure

ref = r1;

r1a = r1 - ref;
r2a = r2 - ref;
r3a = r3 - ref;
r4a = r4 - ref;
r5a = r5 - ref;
r6a = r6 - ref;

subplot(2,3,1),plot(r1,'b');
title('Channel 1');
hold on
subplot(2,3,1),plot(r1a,'r');
axis([0 200 -15 15]);
subplot(2,3,2),plot(r2,'b');
title('Channel 2');
hold on
subplot(2,3,2),plot(r2a,'r');
axis([0 200 -15 15]);
subplot(2,3,3),plot(r3,'b');
title('Channel 3');
hold on
subplot(2,3,3),plot(r3a,'r');
axis([0 200 -15 15]);
subplot(2,3,4),plot(r4,'b');
hold on
subplot(2,3,4),plot(r4a,'r');
title('Channel 4');
axis([0 200 -15 15]);
subplot(2,3,5),plot(r5,'b');
hold on
subplot(2,3,5),plot(r5a,'r');
title('Channel 5');
axis([0 200 -15 15]);
subplot(2,3,6),plot(r6,'b');
title('Channel 6');
hold on
subplot(2,3,6),plot(r6a,'r');
axis([0 200 -15 15]);

suplabel('Referenced Data','t');

pause

% Rereferenced Data

figure

ref = r6;

r11 = r1 - ref;
r21 = r2 - ref;
r31 = r3 - ref;
r41 = r4 - ref;
r51 = r5 - ref;
r61 = r6 - ref;

subplot(2,3,1),plot(r1,'b');
title('Channel 1');
hold on
subplot(2,3,1),plot(r11,'r');
axis([0 200 -15 15]);
subplot(2,3,2),plot(r2,'b');
title('Channel 2');
hold on
subplot(2,3,2),plot(r21,'r');
axis([0 200 -15 15]);
subplot(2,3,3),plot(r3,'b');
title('Channel 3');
hold on
subplot(2,3,3),plot(r31,'r');
axis([0 200 -15 15]);
subplot(2,3,4),plot(r4,'b');
hold on
subplot(2,3,4),plot(r41,'r');
title('Channel 4');
axis([0 200 -15 15]);
subplot(2,3,5),plot(r5,'b');
hold on
subplot(2,3,5),plot(r51,'r');
title('Channel 5');
axis([0 200 -15 15]);
subplot(2,3,6),plot(r6,'b');
title('Channel 6');
hold on
subplot(2,3,6),plot(r61,'r');
axis([0 200 -15 15]);

suplabel('Rereferenced Data: Single Channel','t');

pause

% Rereferenced Data

figure

ref = (r5+r6)/2;

r11 = r1 - ref;
r21 = r2 - ref;
r31 = r3 - ref;
r41 = r4 - ref;
r51 = r5 - ref;
r61 = r6 - ref;

subplot(2,3,1),plot(r1,'b');
title('Channel 1');
hold on
subplot(2,3,1),plot(r11,'r');
axis([0 200 -15 15]);
subplot(2,3,2),plot(r2,'b');
title('Channel 2');
hold on
subplot(2,3,2),plot(r21,'r');
axis([0 200 -15 15]);
subplot(2,3,3),plot(r3,'b');
title('Channel 3');
hold on
subplot(2,3,3),plot(r31,'r');
axis([0 200 -15 15]);
subplot(2,3,4),plot(r4,'b');
hold on
subplot(2,3,4),plot(r41,'r');
title('Channel 4');
axis([0 200 -15 15]);
subplot(2,3,5),plot(r5,'b');
hold on
subplot(2,3,5),plot(r51,'r');
title('Channel 5');
axis([0 200 -15 15]);
subplot(2,3,6),plot(r6,'b');
title('Channel 6');
hold on
subplot(2,3,6),plot(r61,'r');
axis([0 200 -15 15]);

suplabel('Rereferenced Data: Two Channels','t');

pause

close all
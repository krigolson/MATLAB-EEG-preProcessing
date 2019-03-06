close all;
clear all;
clc;

cam = imread('cam.jpg');
subplot(1,2,1);
imshow(cam);
WaitSecs(2);
tempcam = cam;
pause;

for counter = 1:30
    
    tempcam = cam;
    h = fspecial('average', [counter counter]);
    newcam = imfilter(tempcam, h);
    subplot(1,2,2);
    imshow(newcam);
    drawnow;

    WaitSecs(1);
    
end


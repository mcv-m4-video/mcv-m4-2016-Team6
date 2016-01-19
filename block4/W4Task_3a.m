%TASK 3: Align the two frames

clear all; close all; 


%Stabilization Pixels: Max displacement
sp = 10;

addpath('devkit_Stereo_flow\devkit\matlab\');

% KITTY
image1 = double(imread('data_stereo_flow\training\image_0\000157_10.png'));
image2 = double(imread('data_stereo_flow\training\image_0\000157_11.png'));

% Frame difference without alignement
frameDifference = sum(sum(abs(image1(sp+1:end-sp,sp+1:end-sp) - image2(sp+1:end-sp,sp+1:end-sp))));
msg = sprintf('Frame difference before alignement: %d ',frameDifference); disp(msg);

[row, col] = size(image1);

% Apply Block Matching to the image
% Swaping image1 and image2 you can swap between forward and backwar motion
% estimation??? Also changing the direction of the resulting vectors????
p = 8;
blockSize = 20;
[motion] = blockMathcing(image1, image2, blockSize, p);
dX = motion(:,:,1);
dY = motion(:,:,2);

%Compute mean motion
meandX = round(mean(dX(:)));
meandY = round(mean(dY(:)));

if meandX > sp
    meandX = sp;
    disp('X Motion bigger than stabilization pixels');
end
if meandY > sp
    meandY = sp;
    disp('Y Motion bigger than stabilization pixels');
end

%Crop image1
newImage1 = image1(sp+1:end-sp,sp+1:end-sp);

%Crop image2 taking into account motion
newImage2 = image2(sp+1+meandY:end-sp+meandY,sp+1+meandX:end-sp+meandX);


% Frame difference affter alignement
frameDifference = sum(sum(abs(newImage1 - newImage2)));
msg = sprintf('Frame difference affter alignement: %d ',frameDifference); disp(msg);

%Save images
imwrite(uint8(newImage1),'newImage1.png');
imwrite(uint8(newImage2),'newImage2.png');



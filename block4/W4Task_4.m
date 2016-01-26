%% OPTICAL FLOW
% clear all; close all; dbstop error;

Movie_from_frames('flow1',0.2);

%% FIRST METHOD: HORN-SCHUNCK METHOD
vidReader = VideoReader('flow1.avi');
opticFlow = opticalFlowHS('Smoothness',1,'MaxIteration',10,'VelocityDifference',0);
while hasFrame(vidReader)
    frameRGB = readFrame(vidReader);
    frameGray = rgb2gray(frameRGB);
    % Compute optical flow
    flow = estimateFlow(opticFlow, frameGray); 
    % Display video frame with flow vectors
    figure;
    imshow(frameRGB) 
    hold on
    plot(flow, 'DecimationFactor', [5 5], 'ScaleFactor', 30)
    hold off 
end
[fil,col] = size(flow.Vx);
flow1 = zeros(fil,col,2);
flow1(:,:,1) = flow.Vx;
flow1(:,:,2) = flow.Vy;

%% SECOND METHOD
im1 = double(imread('data_stereo_flow\training\image_0\000157_11.png'));
im2 = double(imread('data_stereo_flow\training\image_0\000157_10.png'));
uv = estimate_flow_interface(im1, im2, 'classic+nl-fast');

%% EVALUATE RESULTS
% Load the Kitty ground truth for the image
F_gt  = flow_read('data_stereo_flow\training\flow_noc\000157_10.png');
% Number of valid coordinates of the groundtruth
numValidPixels = sum(sum(F_gt(:,:,3)));
% COnsider a fail if the magnitude is greater than TAU
tau = 3;

error_magnitude_1 = sqrt( ( flow1(:,:,1) - F_gt(:,:,1) ).^2 + ( flow1(:,:,2) - F_gt(:,:,2) ).^2 ) .* F_gt(:,:,3);
MMEN_1 = sum(error_magnitude_1(:))/numValidPixels;
PEPN_1 =  sum(error_magnitude_1(:) > tau)/ numValidPixels;

error_magnitude_2 = sqrt( ( uv(:,:,1) - F_gt(:,:,1) ).^2 + ( uv(:,:,2) - F_gt(:,:,2) ).^2 ) .* F_gt(:,:,3);
MMEN_2 = sum(error_magnitude_2(:))/numValidPixels;
PEPN_2 =  sum(error_magnitude_2(:) > tau)/ numValidPixels;

msg = sprintf('HORN-SCHUNCK METHOD : MMEN=%.3f PEPN=%.3f\nSECOND METHOD : MMEN=%.3f PEPN=%.3f', MMEN_1, PEPN_1, MMEN_2, PEPN_2);
disp(msg);

%% PLOT RESULTS
data = im1;
px = flow1(:,:,1);
py = flow1(:,:,2);
figure;
imshow(data, [])
s = size(data);
hold on;
% [Nx, Ny] = size(im1);
% xidx = 1:10:Nx;
% yidx = 1:10:Ny;
% [X,Y] = meshgrid(xidx,yidx);
% quiver(Y',X',abs(px(xidx,yidx)),abs(py(xidx,yidx)));
quiver(px,py);

px = uv(:,:,1);
py = uv(:,:,2);
figure;
imshow(data, [])
s = size(data);
hold on;
% [Nx, Ny] = size(im1);
% xidx = 1:10:Nx;
% yidx = 1:10:Ny;
% [X,Y] = meshgrid(xidx,yidx);
% quiver(Y',X',abs(px(xidx,yidx)),abs(py(xidx,yidx)));
quiver(px,py);
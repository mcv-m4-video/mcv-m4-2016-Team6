clear all; close all; dbstop error;

% KITTY
image1 = double(imread('data_stereo_flow\training\image_0\000157_10.png'));
image2 = double(imread('data_stereo_flow\training\image_0\000157_11.png'));

[row, col] = size(image1);


% Apply Block Matching to the image
% Swaping image1 and image2 you can swap between forward and backwar motion
% estimation??? Also changing the direction of the resulting vectors????
p = 8;
blockSize = 20;
[motion] = blockMathcing(image1, image2, blockSize, p);
dX = motion(:,:,1);
dY = motion(:,:,2);

% Plot the result of applying block mathcing to the image
% Plotting 1 motion vector per block
[X Y] = meshgrid(1:blockSize:col, 1:blockSize:row);
q = quiver(X, Y, dX(1:blockSize:row, 1:blockSize:col), dY(1:blockSize:row, 1:blockSize:col));
q.AutoScaleFactor = 1;


% Load the result of applying Lukas Kanade to the image
F_est = flow_read('results_opticalflow_kitti\results\LKflow_000157_10.png');
% Load the Kitty ground truth for the image
F_gt  = flow_read('data_stereo_flow\training\flow_noc\000157_10.png');

% Number of valid coordinates of the groundtruth
numValidPixels = sum(sum(F_gt(:,:,3)));

% COnsider a fail if the magnitude is greater than TAU
tau = 3;

% Compute metrics for out block matching implementation
error_magnitude_1 = sqrt( ( motion(:,:,1) - F_gt(:,:,1) ).^2 + ( motion(:,:,2) - F_gt(:,:,2) ).^2 ) .* F_gt(:,:,3);
MMEN_1 = sum(error_magnitude_1(:))/numValidPixels;
PEPN_1 =  sum(error_magnitude_1(:) > tau)/ numValidPixels;

% Compute meetrics for Lukas Kanade
error_magnitude_2 = sqrt( ( F_est(:,:,1) - F_gt(:,:,1) ).^2 + ( F_est(:,:,2) - F_gt(:,:,2) ).^2 ) .* F_gt(:,:,3);
MMEN_2 = sum(error_magnitude_2(:))/numValidPixels;
PEPN_2 =  sum(error_magnitude_2(:) > tau)/ numValidPixels;


msg = sprintf('Block Matching : MMEN=%.3f PEPN=%.3f\nLukas Kanade Block Matching : MMEN=%.3f PEPN=%.3f', MMEN_1, PEPN_1, MMEN_2, PEPN_2);
disp(msg);
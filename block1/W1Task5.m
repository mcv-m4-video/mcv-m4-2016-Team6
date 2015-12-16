disp('======= KITTI DevKit Demo =======');
clear all; close all; dbstop error;

% error threshold
tau = 3;

%% 000157
disp('Load and show optical flow field ... ');
im0 = imread('training\image_0\000157_10.png');
im1 = imread('training\image_0\000157_11.png');
figure;
subplot(3,1,1);imshow(im0);
subplot(3,1,2);imshow(im1);
im_diff = im0-im1;
subplot(3,1,3);imshow(im_diff);
% F_est = flow_read('data/flow_est.png');
% F_gt  = flow_read('data/flow_gt.png');
F_est = flow_read('results\LKflow_000157_10.png');
F_gt  = flow_read('training\flow_noc\000157_10.png');
f_err = flow_error(F_gt,F_est,tau);
F_err = flow_error_image(F_gt,F_est);
figure,imshow([flow_to_color([F_est;F_gt]);F_err]);
title(sprintf('Error: %.2f %%',f_err*100));
figure,flow_error_histogram(F_gt,F_est);

%% 00045
disp('Load and show optical flow field ... ');
im0 = imread('training\image_0\000045_10.png');
im1 = imread('training\image_0\000045_11.png');
figure;
subplot(3,1,1);imshow(im0);
subplot(3,1,2);imshow(im1);
im_diff = im0-im1;
subplot(3,1,3);imshow(im_diff);
% F_est = flow_read('data/flow_est.png');
% F_gt  = flow_read('data/flow_gt.png');
F_est = flow_read('results\LKflow_000045_10.png');
F_gt  = flow_read('training\flow_noc\000045_10.png');
f_err = flow_error(F_gt,F_est,tau);
F_err = flow_error_image(F_gt,F_est);
figure,imshow([flow_to_color([F_est;F_gt]);F_err]);
title(sprintf('Error: %.2f %%',f_err*100));
figure,flow_error_histogram(F_gt,F_est);
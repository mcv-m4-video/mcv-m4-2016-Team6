function [  ] = plotErrorVectors( fileNameGT, fileNameEstimation )
%Plots OF error vectors
%Input: GT and estimation optical flow filenames.
%Displays motion vector errors 

%Read files
F_gt = flow_read(fileNameGT);
F_est = flow_read(fileNameEstimation);

%Compute u,v
F_gt_du  = shiftdim(F_gt(:,:,1));
F_gt_dv  = shiftdim(F_gt(:,:,2));

F_est_du = shiftdim(F_est(:,:,1));
F_est_dv = shiftdim(F_est(:,:,2));

%Compute MSE
E_du = F_gt_du-F_est_du;
E_dv = F_gt_dv-F_est_dv;

%Plot vectors
q = quiver(E_du(1:10:end,1:10:end),E_dv(1:10:end,1:10:end));
% q.LineWidth = 2;
q.AutoScaleFactor = 5;



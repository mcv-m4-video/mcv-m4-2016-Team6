% Task 1: Gaussian distribution
% Computes means and variances of training set, computes the best alpha
% parameter (maximizes AUC), and saves the segmentation belonging to this
% alpha.

clc
clear all
close all

%% SELECT THE FOLDER
imagesID = 'highway';

%% TRAINING
disp(['Start training for... ' imagesID]);
imdir = '/firsthalf/';

%Load frames
[images, filenames, numImages] = LoadFrames(imagesID, imdir);

%Compute means
disp('Computing means...');
means = ComputeMeans(imagesID, images, filenames, numImages);

%Compute variances
disp('Computing variances...');
variances = ComputeVariances(imagesID, images, filenames, numImages, means);

%Compute sigmas
disp('Computing sigmas...');
sigmas = sqrt(variances);

%% EVALUATION
disp(['Start evaluation for... ' imagesID]);
imdir = '/secondhalf/';

alpha = 0:0.2:5;

[images, filenames, numImages] = LoadFrames(imagesID, imdir);

LoadAllAlphas( alpha, images, filenames, imagesID,  numImages, means, variances, sigmas );

bestalpha = GetBestAlpha( alpha, images, filenames, imagesID, numImages);
disp(['Best alpha for ' imagesID ' is ' bestalpha]);

%% SAVE RESULTS
disp(['Saving results for alpha = ' bestalpha])
SaveResults( bestalpha, imagesID, numImages, 'nonrec');

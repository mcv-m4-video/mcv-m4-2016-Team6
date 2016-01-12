% Task 4: Adaptive Gaussian distribution
% Computes means and variances of training set, uses best alpha computed in Task 1 
% to calculate best rho, and saves the segmentation belonging to this

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

bestalpha = 2;
rho = 0:0.05:0.5;

[images, filenames, numImages] = LoadFrames(imagesID, imdir);

LoadAllRhos( bestalpha, rho, images, filenames, imagesID, numImages, means, variances, sigmas );

bestrho = GetBestRho( bestalpha, rho, images, filenames, imagesID, numImages);
disp(['Best rho for ' imagesID ' is ' bestrho]);

%% SAVE RESULTS
disp(['Saving results for rho = ' bestrho])
SaveResults( bestrho, imagesID, numImages, 'rec', 'rho');

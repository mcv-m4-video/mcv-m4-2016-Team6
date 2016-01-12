% Task 4: Adaptive Gaussian distribution
% Computes means and variances of training set, uses best alpha computed in Task 1 
% to calculate best rho, and saves the segmentation belonging to this

%Execute once per sequence and then run evaluate.m to see results.
clc
clear all
close all

%% SELECT THE FOLDER
imagesID = 'Fall';

%Already computed aplha
bestalpha = 3; %Highway
% bestalpha = 3.2; %Fall
% bestalpha = 3.8; %Highway

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

%% CLASSIFICATION
disp(['Start evaluation for... ' imagesID]);
imdir = '/secondhalf/';
[images, filenames, numImages] = LoadFrames(imagesID, imdir);

rho = 0:0.1:1;
%Saves .mat files with results for differents rhos to be evaluated with evaluate.m
classifyWithDifferentRhos( bestalpha, rho, images, filenames, imagesID, numImages, means, variances, sigmas )

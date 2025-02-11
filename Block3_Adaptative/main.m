% Task 4: Adaptive Gaussian distribution
% Computes means and variances of training set, uses best alpha computed in Task 1 
% to calculate best rho, and saves the segmentation belonging to this

%Execute once per sequence and then run evaluate.m to see results.
clc
clear all
close all
dbstop error

%% CONFIG
imagesIDs = {'trafficStab'};
bestrhos = [0.2, 0.2];

    %Already computed rhos (maybe bad approximation)
    % bestrho = 3; %Highway
    % bestrho = 3.2; %Fall
    % bestrho = 3.8; %Highway
    
for type=1:length(imagesIDs)
    
    imagesID = imagesIDs{type};
    bestrho = bestrhos(type);
    disp(imagesID);

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

    alpha = 0.1:1:10;
    %Saves .mat files with results for differents rhos to be evaluated with evaluate.m
    classifyWithDifferentAlphas( alpha, bestrho, images, filenames, imagesID, numImages, means, variances, sigmas )
end
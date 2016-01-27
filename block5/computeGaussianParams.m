function [means, variances, sigmas] = computeGaussianParams(imdir, imagesID)

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

end
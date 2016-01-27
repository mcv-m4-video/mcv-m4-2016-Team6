function [means, variances, sigmas] = initializeSegmentation(numFrames, imagesID)


%% TRAINING
disp(['Start training for... ' imagesID]);

imdir = '/firsthalf/';

[means, variances, sigmas] = computeGaussianParams(imdir, imagesID);

end
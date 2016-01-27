function saveSequenceBestParams(bestalpha, bestrho, imagesID, imdir, means, variances, sigmas)

%% EVALUATION
disp(['Start evaluation for... ' imagesID]);
imdir = '/secondhalf/';

[images, filenames, numImages] = LoadFrames(imagesID, imdir);

LoadBestSequence(bestalpha, bestrho, images, filenames, imagesID, numImages, means, variances, sigmas);

%% SAVE RESULTS
disp('Saving results...')
SaveResults( bestrho, imagesID, numImages);

end

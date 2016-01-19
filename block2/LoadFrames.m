function [ images, filenames, numImages ] = LoadFrames( imagesID, imdir )
%LOADFRAMES 
%   Loads images for Gaussian modeling in the training directory
%   Input: name of sequence and directory (firsthalf or secondhalf)

directory = [imagesID, imdir];
imagesData = dir(directory);
imagesData = imagesData(3:end);

% Count the number of files
numImages = numel(imagesData);

% Load frames
filenames = [];
for i = 1:numImages
    name = imagesData(i).name;
    filenames = [filenames; cellstr(name)];
    filepath = strcat(directory,filenames(i));
    images{i} = double(rgb2gray(imread(filepath{1})));
end

end


function [ images, filenames, numImages ] = loadRGBframes( imagesID, imdir )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here

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
    images{i} = double((imread(filepath{1})));
end

end


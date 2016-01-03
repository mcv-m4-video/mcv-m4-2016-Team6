clc
clear all

%%TRAINING

% Model each background pixel with a Gaussian function

directory = '../week2dataset/highway/firsthalf/';
imagesData = ListFiles(directory);

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

%Compute means
means = zeros(size(images{1}));
for i=1:numImages
    curImage = images{i};
    means(:,:) = means(:,:) + curImage(:,:);
end
means = means./numImages;

%Compute variances
variances = zeros(size(images{1}));
for i=1:numImages
    curImage = images{i};
    variances(:,:) = variances(:,:) + power(curImage(:,:) - means(:,:),2);
end
variances = variances./numImages;

%Compute sigmas
sigmas = sqrt(variances);

%%

%%EVALUATION   %Should be modified to save results and evaluate them
alpha = 1;
directory = '../week2dataset/highway/secondhalf/';
imagesData = ListFiles(directory);

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

%Classify pixels
[width,heigh] = size(images{1});
for i=1:numImages   %For each image
    curImage = images{i};
    for m=1:width %For each pixel
        for n=1:heigh
            if abs(curImage(m,n) - means(m,n)) > alpha * (variances(m,n) + 2) %+2 to prevent low values
                curImage(m,n) = 255;    %pixel is Foreground
            else
                curImage(m,n) = 0;    %pixel is Background
            end 
        end 
    end
     images{i} = curImage;  %Save the mask
end
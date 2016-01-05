% Task 1: Gaussian distribution
clc
clear all
close all

%% SELECT THE FOLDER
imagesID = 'traffic';

%% TRAINING
disp(strcat('Start training for...',imagesID));

% Model each background pixel with a Gaussian function
directory = [imagesID +'/firsthalf/'];
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
disp('Computing means...');
means = zeros(size(images{1}));
for i=1:numImages
    curImage = images{i};
    gt_name = strcat('gt', filenames{i}(3:8), '.png');
    importfile(strcat(imagesID, '/groundtruth/', gt_name));
    % For every background pixel... 255, 170, 85, 50, 0
    [fil, col] = size(cdata);
    for fil=1:fil
        for col=1:col
            if cdata(fil, col) <= 50
                means(fil,col) = means(fil,col) + curImage(fil,col);
            end
        end
    end
end
means = means./numImages;

%Compute variances
disp('Computing variances...');
variances = zeros(size(images{1}));
for i=1:numImages
    curImage = images{i};
    gt_name = strcat('gt', filenames{i}(3:8), '.png');
    importfile(strcat(imagesID, '/groundtruth/', gt_name));
    % For every background pixel... 255, 170, 85, 50, 0
    [fil, col] = size(cdata);
    for fil=1:fil
        for col=1:col
            if cdata(fil,col) <= 50
                variances(fil,col) = variances(fil,col) + power(curImage(fil,col) - means(fil,col),2);
            end
        end
    end
end
variances = variances./numImages;

%Compute sigmas
disp('Computing sigmas...');
sigmas = sqrt(variances);

%% EVALUATION
disp(strcat('Start evaluation for...',imagesID));

%Should be modified to save results and evaluate them
alpha = 0:0.2:5;
directory = [imagesID +'/secondhalf/'];
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

for thIndex=1:length(alpha)
    %Classify pixels
    curAlpha = alpha(thIndex);
    [width,heigh] = size(images{1});
    for i=1:numImages   %For each image
        gt_name = strcat('gt', filenames{i}(3:8), '.png');
        importfile(strcat(imagesID, '/groundtruth/', gt_name));
        gt_evaluation{i,1} = cdata;
        gt_evaluation{i,2} = gt_name;
        curImage = images{i};
        for m=1:width %For each pixel
            for n=1:heigh
                if abs(curImage(m,n) - means(m,n)) >= (curAlpha*(sigmas(m,n)+2)) %+2 to prevent low values
                    curImage(m,n) = 255;    %pixel is Foreground
                else
                    curImage(m,n) = 0;    %pixel is Background
                end 
            end 
        end
        mask_images{i} = curImage;  %Save the image mask
    end
    filename = strcat(imagesID, '/', imagesID, '-alpha-', num2str(thIndex), '.mat');
    save(filename, 'mask_images'); %Save maskimages for current alpha
    filename = strcat(imagesID, '/gt_evaluation.mat');
    save(filename, 'gt_evaluation');
end

%% Show results
% figure;
% subplot(1,2,1); imshow(mask_images{end-2}); title(filenames{end-2});
% subplot(1,2,2); imshow(gt_evaluation{end-2}); title(gt_evaluation{end-2,2});

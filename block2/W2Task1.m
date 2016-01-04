clc;
clear all;
imagesID = 'highway';

%%TRAINING

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
means = zeros(size(images{1}));
for i=1:numImages 
    curImage = images{i};
    gt_name = strcat('gt', filenames{i}(3:8), '.png');
    importfile(strcat(imagesID, '/groundtruth/', gt_name));
    % For every background pixel... 255, 170, 85, 50, 0
    [fil, col] = size(cdata);
    for fil=1:fil
        for col=1:col
            if cdata(fil, col) < 50
                means(fil,col) = means(fil,col) + curImage(fil,col);
            end
        end
    end
end
means = means./numImages;

%Compute variances
variances = zeros(size(images{1}));
for i=1:numImages
    curImage = images{i};
    gt_name = strcat('gt', filenames{i}(3:8), '.png');
    importfile(strcat(imagesID, '/groundtruth/', gt_name));
    % For every background pixel... 255, 170, 85, 50, 0
    [fil, col] = size(cdata);
    for fil=1:fil
        for col=1:col
            if cdata(fil, col) < 50
                variances(fil,col) = variances(fil,col) + power(curImage(fil,col) - means(fil,col),2);
            end
        end
    end
end
variances = variances./numImages;

%Compute sigmas
sigmas = sqrt(variances);

%%

%%EVALUATION   %Should be modified to save results and evaluate them
alpha = 1:1:15;
directory = [imagesID +'/secondhalf/'];
imagesData = ListFiles(directory);

% Count the number of files
numImages = numel(imagesData);

for thIndex=1:length(alpha)
    curAlpha = alpha(thIndex);
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
                if abs(curImage(m,n) - means(m,n)) > curAlpha * (variances(m,n) + 2) %+2 to prevent low values
                    curImage(m,n) = 255;    %pixel is Foreground
                else
                    curImage(m,n) = 0;    %pixel is Background
                end 
            end 
        end
         images{i} = curImage;  %Save the mask
    end
    filename = strcat(imagesID, '/', imagesID, '-alpha-', num2str(curAlpha), '.mat');
    save (filename, 'images')
end

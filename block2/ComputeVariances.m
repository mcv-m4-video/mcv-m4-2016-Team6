function [ variances ] = ComputeVariances( imagesID, images, filenames, numImages, means )
%COMPUTEVARIANCES
%   Computes matrix of variance of each pixel in training set

variances = zeros(size(images{1}));
for i=1:numImages
    curImage = images{i};
    gt_name = strcat('gt', filenames{i}(3:8), '.png');
%     importfile(strcat(imagesID, '/groundtruth/', gt_name));
    cdata = imread(strcat(imagesID, '/groundtruth/', gt_name));
%     For every background pixel... 255, 170, 85, 50, 0
    [fil, col] = size(cdata);
    for fil=1:fil
        for col=1:col
            if cdata(fil, col) <= 50
                variances(fil,col) = variances(fil,col) + power(curImage(fil,col) - means(fil,col),2);
            end
        end
    end
end
variances = variances./numImages;

end


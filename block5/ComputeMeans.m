function means = ComputeMeans(imagesID, images, filenames, numImages )
%COMPUTEMEANS
%   Computes matrix of mean value of each pixel in training set

means =zeros(size(images{1}));
for i=1:numImages
    curImage = images{1,i};
    gt_name = strcat('gt', filenames{i}(3:8), '.png');
%     importfile(strcat(imagesID, '/groundtruth/', gt_name));
    cdata = imread(strcat(imagesID, '/groundtruth/', gt_name));
%     For every background pixel... 255, 170, 85, 50, 0
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

end


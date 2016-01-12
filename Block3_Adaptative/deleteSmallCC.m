function [ ] = deleteSmallCC(  )
connectivity = 4;
minPixels = 10;
%Loads the maks with holes filled, deletes small connected components and
%saves the masks in /sequence/deleteSmallCC

imagesID = {'highway', 'fall', 'traffic'};

for type=1:length(imagesID)
    dir = strcat(imagesID , '/deleteSmallCC');
    mkdir(dir{1});
    
    directory = [imagesID{type} +'/secondhalf/'];
    imagesData = ListFiles(directory);
    % Count the number of files
    numImages = numel(imagesData);
    
    %Load masks
    for alpha=1:11
        filename = strcat(imagesID{type}, '/fillHoles/', imagesID{type}, '-alpha-', num2str(alpha), '.mat');
        load(filename);
        for i=1:numImages
            curImage = mask_images{i};
            curImage = bwareaopen(curImage, minPixels, connectivity);           
            mask_images{i} = curImage;  %Save the image mask
        end
        newFilename = strcat(imagesID, '/deleteSmallCC/', imagesID, '-alpha-', num2str(alpha), '.mat');
        save(newFilename{1}, 'mask_images'); %Save maskimages for current alpha
    end

end




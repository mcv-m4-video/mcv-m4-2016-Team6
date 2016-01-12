function [ ] = deleteSmallCC(  )
connectivity = 4;
minPixels = 0:4:60;
%Loads the maks with holes filled, deletes small connected components and
%saves the masks in /sequence/deleteSmallCC

imagesID = {'highway', 'fall', 'traffic'};

for curMinPixels=1:length(minPixels)

    for type=1:length(imagesID)
        dir = strcat(imagesID(type) , '/deleteSmallCC/', num2str(curMinPixels));
        mkdir(dir{1});

        directory = [imagesID{type} +'/secondhalf/'];
        imagesData = ListFiles(directory);
        % Count the number of files
        numImages = numel(imagesData);

        %Load masks
        for alpha=1:10
            filename = strcat(imagesID{type}, '/fillHoles/', imagesID{type}, '-alpha-', num2str(alpha), '.mat');
            load(filename);
            for i=1:numImages
                curImage = mask_images{i};
                curImage = bwareaopen(curImage, curMinPixels, connectivity);           
                mask_images{i} = curImage;  %Save the image mask
            end
            newFilename = strcat(imagesID{type}, '/deleteSmallCC/',num2str(curMinPixels),'/', imagesID{type}, '-alpha-', num2str(alpha), '.mat');
            save(newFilename, 'mask_images'); %Save maskimages for current alpha
        end

    end
    
end




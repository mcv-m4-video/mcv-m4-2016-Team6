function [ ] = fillHoles(  )
connectivity = 4;
%Loads the maks, fills the holes and saves the masks in /sequence/fillHoles
imagesIDs = {'highway', 'fall', 'traffic'};

for type=1:length(imagesIDs)
    
    imagesID = imagesIDs{type};
    dir = strcat(imagesID , '/fillHoles');
    mkdir(dir);
    
    directory = [imagesID +'/secondhalf/'];
    imagesData = ListFiles(directory);
    % Count the number of files
    numImages = numel(imagesData);
    
    %Load masks
    for alpha=1:10
        filename = strcat(imagesID, '/', imagesID, '-alpha-', num2str(alpha), '.mat');
        load(filename);
        for i=1:numImages
            curImage = mask_images{i};
            curImage =  imfill(curImage, connectivity, 'holes');
            mask_images{i} = curImage;  %Save the image mask
        end
        newFilename = strcat(imagesID, '/fillHoles/', imagesID, '-alpha-', num2str(alpha), '.mat');
        save(newFilename, 'mask_images'); %Save maskimages for current rho
    end

end


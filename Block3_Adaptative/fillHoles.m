function [ ] = fillHoles(  )
connectivity = 4;
%Loads the maks, fills the holes and saves the masks in /sequence/fillHoles
imagesID = {'highway'};

for type=1:length(imagesID)
    dir = strcat(imagesID , '/fillHoles');
    mkdir(dir{1});
    
    directory = [imagesID{type} +'/secondhalf/'];
    imagesData = ListFiles(directory);
    % Count the number of files
    numImages = numel(imagesData);
    
    %Load masks
    for rho=1:11
        filename = strcat(imagesID{type}, '/', imagesID{type}, '-rho-', num2str(rho), '.mat');
        load(filename);
        for i=1:numImages
            curImage = mask_images{i};
            curImage =  imfill(curImage, connectivity, 'holes');
            mask_images{i} = curImage;  %Save the image mask
        end
        newFilename = strcat(imagesID, '/fillHoles/', imagesID, '-rho-', num2str(rho), '.mat');
        save(newFilename{1}, 'mask_images'); %Save maskimages for current rho
    end

end


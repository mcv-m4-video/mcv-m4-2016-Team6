%% Shadow removal
clear all; close all; clc;

imagesIDs = {'highway', 'fall', 'traffic'};
    
for type=1:length(imagesIDs)
    
    imagesID = imagesIDs{type};    
    
    % Load color frames
    imdir = '/secondhalf/'; 
    [rgb_images, filenames, numImages] = loadRGBframes(imagesID, imdir);
    % Load reconstructed masks
    imdir = '/reconstruction/4/';
    dir = strcat(imagesID,imdir,imagesID,'-alpha-3.mat');
    mask_images = load(dir);
    mask_images = mask_images.mask_images;
    
    for i=1:numImages-1
        
        disp([num2str(i) '/' num2str(numImages-1) ' ' imagesID]);
        
        % Create shadow masks
        shadow_image = removeShadows(rgb_images{i},rgb_images{i+1});
        shadows{i} = shadow_image;
        
        % Remove shadows from masks
        new_mask_image = removeShadowInMask(mask_images{i},shadow_image);
        new_mask_images{i} = new_mask_image;
    end
    
    dir = strcat(imagesID,'/shadows.mat');
    save(dir, 'shadows');
    dir = strcat(imagesID,'/new_masks.mat');
    save(dir, 'new_mask_images');
end
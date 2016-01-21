function [  ] = task4_reconstruction( )
%Task4: Reconstruction

minPixels = 1:2:11;
%Loads the maks with holes filled, apply recosntruction
%saves the masks in /sequence/reconstruction

imagesID = {'trafficStab'};

for curMinPixels=1:length(minPixels)
    curMinPixels
    SE = ones(minPixels(curMinPixels), minPixels(curMinPixels));
    
    for type=1:length(imagesID)
        type
        dir = strcat(imagesID(type) , '/reconstruction/', num2str(curMinPixels));
        mkdir(dir{1});

        directory = [imagesID{type} +'/secondhalf/'];
        imagesData = ListFiles(directory);
        % Count the number of files
        numImages = numel(imagesData);

        %Load masks
        for alpha=1:10
            alpha
            filename = strcat(imagesID{type}, '/fillHoles/', imagesID{type}, '-alpha-', num2str(alpha), '.mat');
            load(filename);
            for i=1:numImages
                curImage = mask_images{i};
                
                %Reconstruction by erosion              
                marker = myerode(curImage,SE);
                curImage = reconstruct(curImage, marker);
                
                mask_images{i} = curImage;  %Save the image mask
            end
            newFilename = strcat(imagesID{type}, '/reconstruction/',num2str(curMinPixels),'/', imagesID{type}, '-alpha-', num2str(alpha), '.mat');
            save(newFilename, 'mask_images'); %Save maskimages for current alpha
        end

    end
    
end





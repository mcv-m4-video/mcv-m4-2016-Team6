function [  ] = task4_tophat( )
%Task4: TOPHAT

minPixelsTH = 5:2:15;
minPixelsOP = 1:2:11;
%Loads the maks with holes filled, apply recosntruction
%saves the masks in /sequence/reconstruction

imagesID = {'highway', 'fall', 'traffic'};

for curMinPixels=1:length(minPixelsTH)
    curMinPixels
    SE = ones(minPixelsTH(curMinPixels), minPixelsTH(curMinPixels));
    SE2 = ones(minPixelsOP(curMinPixels), minPixelsOP(curMinPixels));
    
    for type=1:length(imagesID)
        type
        dir = strcat(imagesID(type) , '/tophat/', num2str(curMinPixels));
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
                
                %Reconstruction by erosion              
                imTopHat = mytophat(curImage, SE);                
                imOpen = myerode(imTopHat,SE2);
                curImage = reconstruct(curImage, imOpen);
                
                mask_images{i} = curImage;  %Save the image mask
            end
            newFilename = strcat(imagesID{type}, '/tophat/',num2str(curMinPixels),'/', imagesID{type}, '-alpha-', num2str(alpha), '.mat');
            save(newFilename, 'mask_images'); %Save maskimages for current alpha
        end

    end
    
end





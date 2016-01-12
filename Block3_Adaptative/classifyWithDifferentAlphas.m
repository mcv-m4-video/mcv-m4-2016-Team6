function classifyWithDifferentAlphas( alpha, bestrho, images, filenames, imagesID, numImages, means, variances, sigmas )

%Save initial values
initialMeans = means;
initialVariances = variances;

for thIndex=1:length(alpha)  % index goes from 1 to length of alpha (11) bc we want to go through each possible alpha
    
    %Reset values
    means = initialMeans;
    variances = initialVariances;
    
    %Classify pixels
    disp(['Alpha:  ' num2str(thIndex)]);
    curAlpha = alpha(thIndex);  % counter for current alpha we're on
    [width,height] = size(images{1}); % get width and height of images
    
    for i=1:numImages   %For each image
        disp(['Image ' num2str(i) ' of ' num2str(numImages)])
        gt_name = strcat('gt', filenames{i}(3:8), '.png');  % get name of ground truth img
%         importfile(strcat(imagesID, '/groundtruth/', gt_name)); % load gt img
        cdata = imread(strcat(imagesID, '/groundtruth/', gt_name));
        gt_evaluation{i,1} = cdata; % 1st cell of gt_evaluation is the gt img matrix
        gt_evaluation{i,2} = gt_name; % 2nd cell is the name of the ground truth
        curImage = images{i};
        for m=1:width %For each pixel
            for n=1:height
                if abs(curImage(m,n) - means(m,n)) >= (curAlpha*(sigmas(m,n)+2)) %+2 to prevent low values
                    curImage(m,n) = 255;    %pixel is Foreground
                    
                    means_update = means;
                    variances_update = variances;
                else
                    curImage(m,n) = 0;    %pixel is Background
                    
                    means_update(m,n) = bestRho*curImage(m,n)+(1-bestRho)*means(m,n); % update means
                    variances_update(m,n) = bestRho*power(curImage(m,n)-means(m,n),2) + ...
                                            (1-bestRho)*power(variances(m,n),2); % update variances
                end
            end 
            mask_images{i} = curImage;  %Save the image mask
        end     
        
        %Set updated values
        means = means_update;
        variances = variances_update;
        
    end
    filename = strcat(imagesID, '/', imagesID, '-alpha-', num2str(thIndex), '.mat');
    save(filename, 'mask_images'); %Save maskimages for current alpha
    filename = strcat(imagesID, '/gt_evaluation.mat');
    save(filename, 'gt_evaluation');
end

end


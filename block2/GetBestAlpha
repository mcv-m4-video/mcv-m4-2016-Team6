function [ bestalpha ] = GetBestAlpha( alpha, images, filenames, imagesID, numImages )

%For each alpha load data and compare with annotations
    imagesID = {imagesID};
    
for type=1:length(imagesID)
    directory = [imagesID{type} +'/secondhalf/'];
    imagesData = dir(directory);
    imagesData = imagesData(3:end);

    % Count the number of files
    numImages = numel(imagesData);

    % Load filenames
    filenames = [];
    for i = 1:numImages
        name = imagesData(i).name;
        filenames = [filenames; cellstr(name)];
    end

    %For each alpha load data and compare with annotations
    gtpath = [imagesID{type} +'/gt_evaluation.mat'];
    load(gtpath);
    for alpha=1:26
        pixelTP = 0; pixelTN = 0; pixelFP = 0; pixelFN = 0;
        filename = strcat(imagesID{type}, '/', imagesID{type}, '-alpha-', num2str(alpha), '.mat');
        load(filename);
        for i=1:numImages
            curImage = mask_images{i};
            cdata = gt_evaluation{i,1};
            % For every background pixel... 255, 170, 85, 50, 0
            [fil, col] = size(cdata);
            for fil=1:fil
                for col=1:col
                    if cdata(fil, col) > 50 && cdata(fil, col) < 255 %Not evaluated 
                    elseif cdata(fil, col) <= 50 && curImage(fil, col) <= 50 %TN (BG)
                           pixelTN = pixelTN + 1;
                    elseif cdata(fil, col) == 255 && curImage(fil, col) == 255 %TP (FG)
                           pixelTP = pixelTP + 1;
                    elseif cdata(fil, col) <= 50  %FP 
                           pixelFP = pixelFP + 1;
                    else %FN
                          pixelFN = pixelFN + 1;
                    end
                end
            end
        end

        pixelPrecision   = pixelTP / (pixelTP+pixelFP);
        pixelSensitivity = pixelTP / (pixelTP+pixelFN);
        pixelF1          = (2*pixelTP) / (2*pixelTP + pixelFP + pixelFN);
        results{type,alpha} = {pixelTP, pixelTN, pixelFP, pixelFN,pixelPrecision,pixelSensitivity,pixelF1};
    end
end

% Plot the results for all types
for type=1:length(imagesID)
    for i=1:alpha
        F1(type,i) = results{type,i}{1,7};
    end
    
    x=0:0.2:5;
end

figure;
plot(x,F1(1,:),'r');
title('F1 score');

[bestF1, index] = max(F1(1,:));
bestalpha = x(index);

end


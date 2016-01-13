function [  ] = evaluateShadows(  )
%UNTITLED3 Summary of this function goes here
%   Detailed explanation goes here
clear all; close all;

imagesID = {'highway', 'fall', 'traffic'};

%     step2evaluate = [file_name]; %Task 2
for type=1:length(imagesID)
    directory = [imagesID{type} +'/secondhalf/'];
    imagesData = ListFiles(directory);

    % Count the number of files
    numImages = numel(imagesData);

    % Load filenames
    filenames = [];
    for i = 1:numImages
        name = imagesData(i);
        filenames = [filenames; cellstr(name)];
    end

    gtpath = [imagesID{type} +'/gt_evaluation.mat'];
    load(gtpath);
    pixelTP = 0; pixelTN = 0; pixelFP = 0; pixelFN = 0;

    filename = strcat(imagesID{type},'/new_masks.mat');
    load(filename);

    for i=1:numImages-1
        curImage = new_mask_images{i};
        cdata = gt_evaluation{i,1};
        % For every background pixel... 255, 170, 85, 50, 0
        [fil, col] = size(cdata);
        for fil=1:fil
            for col=1:col
                if cdata(fil, col) > 50 && cdata(fil, col) < 255 %Not evaluated 
                elseif cdata(fil, col) <= 50 && curImage(fil, col) == 0 %TN (BG)
                       pixelTN = pixelTN + 1;
                elseif cdata(fil, col) == 255 && curImage(fil, col) > 0 %TP (FG)
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
    results{type} = {pixelTP, pixelTN, pixelFP, pixelFN,pixelPrecision,pixelSensitivity,pixelF1};

end   

%% Plot the results for all types
for type=1:length(imagesID)
        TP(type) = results{type}{1,1};
        TN(type) = results{type}{1,2};
        FP(type) = results{type}{1,3};
        FN(type) = results{type}{1,4};
        P(type) = results{type}{1,5};
        R(type) = results{type}{1,6};
        F1(type) = results{type}{1,7};
end 

%Area under Precision vs recall curve
hw_AUC = trapz(P(1),R(1));
fall_AUC = trapz(P(2),R(2));
tff_AUC = trapz(P(3),R(3));

figure;
plot(minPixels,hw_AUC,'r',minPixels,fall_AUC,'g',minPixels,tff_AUC,'b');
legend([imagesID(1), imagesID(2), imagesID(3)]);
xlabel('SE size');
ylabel('AUC');

end


function [Q_NonRec, F1_NonRec, Q_Rec, F1_Rec] = evaluateForegroundMaps(alpha, bestrho, images, non_rec_gauss_masks, rec_gauss_masks, filenames, imagesID, numImages)
   
%Classify pixels
disp(['Alpha:  ' num2str(alpha)]);

[width,height] = size(images{1}); % get width and height of images

%numImages = 1;
for i=1:numImages   %For each image        

    disp(['Image ' num2str(i) ' of ' num2str(numImages)])
    
    % Load GroundTruth
    gt_name = strcat('gt', filenames{i}(3:8), '.png');  % get name of ground truth img
    cdata = imread(strcat(imagesID, '/groundtruth/', gt_name));
    
    % Reursve Gaussian
    Q_Rec(i)= WFb(double(rec_gauss_masks{i}/255),logical(cdata/255));
    F1_Rec(i) = evaluateF1(rec_gauss_masks{i}, cdata);
    msg = sprintf('RecGauss > Q=%.3f f1=%.3f\n', Q_Rec(i), F1_Rec(i));
%     disp(msg);
    
    % NonRecursive Gaussian
    Q_NonRec(i)= WFb(double(non_rec_gauss_masks{i}/255),logical(cdata/255));
    F1_NonRec(i) = evaluateF1(non_rec_gauss_masks{i}, cdata);
    msg = sprintf('NonRecGauss > Q=%.3f f1=%.3f\n', Q_NonRec(i), F1_NonRec(i));
%     disp(msg);
end

end

function [f1_score] = evaluateF1(mask, cdata)

    pixelTP = 0; pixelTN = 0; pixelFP = 0; pixelFN = 0;
    % For every background pixel... 255, 170, 85, 50, 0
    [fil, col] = size(cdata);
    for fil=1:fil
        for col=1:col
            if cdata(fil, col) > 50 && cdata(fil, col) < 255 %Not evaluated 
            elseif cdata(fil, col) <= 50 && mask(fil, col) == 0 %TN (BG)
                   pixelTN = pixelTN + 1;
            elseif cdata(fil, col) == 255 && mask(fil, col) > 0 %TP (FG)
                   pixelTP = pixelTP + 1;
            elseif cdata(fil, col) <= 50  %FP 
                   pixelFP = pixelFP + 1;
            else %FN
                  pixelFN = pixelFN + 1;
            end
        end
    end
    
    pixelPrecision   = pixelTP / (pixelTP+pixelFP);
    pixelSensitivity = pixelTP / (pixelTP+pixelFN);
    pixelF1          = (2*pixelTP) / (2*pixelTP + pixelFP + pixelFN);

    f1_score = pixelF1;
end
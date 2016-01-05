%TASK2: Evaluation
close all

imagesID = 'highway';

directory = [imagesID +'/secondhalf/'];
imagesData = ListFiles(directory);

% Count the number of files
numImages = numel(imagesData);

% Load filenames
filenames = [];
for i = 1:numImages
    name = imagesData(i).name;
    filenames = [filenames; cellstr(name)];
end

%For each alpha load data and compare with annotations
load('gt_evaluation.mat');
for alpha=1:26
    pixelTP = 0; pixelTN = 0; pixelFP = 0; pixelFN = 0;
    filename = strcat(imagesID, '/', imagesID, '-alpha-', num2str(alpha), '.mat');
    load(filename);
    for i=1:numImages
        curImage = mask_images{i};
        cdata = gt_evaluation{i,1};
        % For every background pixel... 255, 170, 85, 50, 0
        [fil, col] = size(cdata);
        for fil=1:fil
            for col=1:col
                if cdata(fil, col) > 50 && cdata(fil, col) < 255 %Not evaluated 
                elseif cdata(fil, col) <= 50 && curImage(fil, col) <= 50 %TP (BG)
                       pixelTP = pixelTP + 1;
                elseif cdata(fil, col) == 255 && curImage(fil, col) == 255 %TN (FG)
                       pixelTN = pixelTN + 1;
                elseif cdata(fil, col) <= 50  %FN 
                       pixelFN = pixelFN + 1;
                else %FP
                      pixelFP = pixelFP + 1;
                end
            end
        end
    end
    
    pixelPrecision   = pixelTP / (pixelTP+pixelFP);
    pixelSensitivity = pixelTP / (pixelTP+pixelFN);
    pixelF1          = (2*pixelTP) / (2*pixelTP + pixelFP + pixelFN);
    results{1,alpha} = {pixelTP, pixelTN, pixelFP, pixelFN,pixelPrecision,pixelSensitivity,pixelF1};
end

%% Plot the results
for i=1:alpha
    TP(i) = results{1,i}{1,1};
    TN(i) = results{1,i}{1,2};
    FP(i) = results{1,i}{1,3};
    FN(i) = results{1,i}{1,4};
    P(i) = results{1,i}{1,5};
    R(i) = results{1,i}{1,6};
    F1(i) = results{1,i}{1,7};
end

x=0:0.2:5;
figure;
plot(x,TP,'-bx',x,TN,'-g^',x,FP,'-ro',x,FN,'-y*');
legend('TP','TN','FP','FN');

figure;
plot(x,F1,'-bo');
legend('F1');

figure;
plot(R,P,'-bx');
legend('P vs R');

figure;
plot(FP,TP,'-rx');
legend('ROC');


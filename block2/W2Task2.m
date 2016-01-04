%TASK2: Evaluation

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
for alpha=1:15
    pixelTP = 0; pixelTN = 0; pixelFP = 0; pixelFN = 0;
    filename = strcat(imagesID, '/', imagesID, '-alpha-', num2str(alpha), '.mat');
    load(filename)
    for i=1:numImages
        curImage = images{i};
        gt_name = strcat('gt', filenames{i}(3:8), '.png');
        importfile(strcat(imagesID, '/groundtruth/', gt_name));
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
                      pixelFN = pixelFN + 1;

                end
            end
        end
    end
    
    pixelPrecision   = pixelTP / (pixelTP+pixelFP);
    pixelSensitivity = pixelTP / (pixelTP+pixelFN);
    pixelF1          = (2*pixelTP) / (2*pixelTP + pixelFP + pixelFN);
    results{alpha} = {alpha, pixelTP, pixelTN, pixelFP, pixelFN,pixelPrecision,pixelSensitivity,pixelF1};
end

            

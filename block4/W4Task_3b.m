%TASK 3: Align traffic sequence frames
clear all; close all; 

%Stabilization Pixels: Max displacement
sp = 20;

addpath('devkit_Stereo_flow\devkit\matlab\');

%Read traffic sequence
directory = '../traffic_full/';
[files, N] = ListFiles(directory);

formerMeandX = 0;
formerMeandY = 0;

%Compute optical flow and apply stabilization for each frame comparing it
%with the previous one. We take into account sabtabilization of that
%previous one.
for i=1:N-1
    % Read images
    image1 = double(imread(files{i}));
    image2 = double(imread(files{i+1}));
    [row, col, c] = size(image1);
    
    %Load annotations
%     gt_name = strcat('gt', files{i+1}(20:end-4), '.png');
%     mask = imread(strcat('gt/', gt_name));

    % Frame difference without alignement
%     frameDifference = sum(sum(abs(image1(sp+1:end-sp,sp+1:end-sp,:) - image2(sp+1:end-sp,sp+1:end-sp,:))));
%     msg = sprintf('Frame difference before alignement: %d \n',frameDifference); disp(msg);

    % Apply Block Matching to the image
    p = 16;
    blockSize = 20;
    
    %Compute motion using grayscale images
    [motion] = blockMathcing(mean(image1,3), mean(image2,3), blockSize, p);
    dX = motion(:,:,1);
    dY = motion(:,:,2);
    

    %Compute mode motion
    meandX = mode(round(dX(:))) + formerMeandX;
    meandY = mode(round(dY(:))) + formerMeandY;

    disp(['Displacement -->   X:' num2str(meandX) '   |    Y: ' num2str(meandY)]);
    
    if meandX > sp
        meandX = sp;
        disp('X Motion bigger than stabilization pixels');
    end
    if meandY > sp
        meandY = sp;
        disp('Y Motion bigger than stabilization pixels');
    end
    if meandX < -sp
        meandX = -sp;
        disp('X Motion bigger than stabilization pixels');
    end
    if meandY < -sp
        meandY = -sp;
        disp('Y Motion bigger than stabilization pixels');
    end
%     
    %Results inicialization
%     newImage2 = imgaussfilt(image1,10);
%     newMask = mask;
%   newImage2 = zeros([row, col, c]);
% 
%     Displace image to achieve alignement
%     if(meandY > 0 && meandX > 0)
%          newImage2(1:end-meandY,1:end-meandX,:) = image2(1+meandY:end,1+meandX:end,:);
%          newMask(1:end-meandY,1:end-meandX,:) = mask(1+meandY:end,1+meandX:end,:);
%     elseif(meandY > 0 && meandX < 0)
%          newImage2(1:end-meandY,1-meandX:end,:) = image2(1+meandY:end,1:end+meandX,:);
%          newMask(1:end-meandY,1-meandX:end,:) = mask(1+meandY:end,1:end+meandX,:);
%     elseif(meandY < 0 && meandX > 0)
%          newImage2(1-meandY:end,1:end-meandX,:) = image2(1:end+meandY,1+meandX:end,:);
%          newMask(1-meandY:end,1:end-meandX,:) = mask(1:end+meandY,1+meandX:end,:);
%     elseif(meandY < 0 && meandX < 0)
%          newImage2(1-meandY:end,1-meandX:end,:) = image2(1:end+meandY,1:end+meandX,:);
%          newMask(1-meandY:end,1-meandX:end,:) = mask(1:end+meandY,1:end+meandX,:);
%     else
%         newImage2 = image2;
%     end
   
 
%     %Crop image2 taking into account motion
    newImage2 = image2(sp+1+meandY:end-sp+meandY,sp+1+meandX:end-sp+meandX,:);
%     newMask = mask(sp+1+meandY:end-sp+meandY,sp+1+meandX:end-sp+meandX,:);


    % Frame difference affter alignement
%     frameDifference = sum(sum(abs(newImage1 - newImage2)));
%     msg = sprintf('Frame difference affter alignement: %d \n',frameDifference); disp(msg);

    %Save current displacement
    formerMeandX = meandX;
    formerMeandY = meandY;

    %Save aligned image
    name = strsplit(files{i+1},'/');
    name = ['atpStab/' name{3}];
    imwrite(uint8(newImage2),name);
    
%     name = ['gtEst/' gt_name];
%     imwrite(newMask,name);
end



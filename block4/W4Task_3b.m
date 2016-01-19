%TASK 3: Align traffic sequence frames
clear all; close all; 

%Stabilization Pixels: Max displacement
sp = 24;

addpath('devkit_Stereo_flow\devkit\matlab\');

%Read traffic sequence
directory = '../traffic/input/';
[files, N] = ListFiles(directory);

formerMeandX = 0;
formerMeandY = 0;

%Compute optical flow and apply stabilization for each frame comparing it
%with the previous one. We take into account sabtabilization of that
%previous one.
for i=1:N-1
    % KITTY
    image1 = double(imread(files{i}));
    image2 = double(imread(files{i+1}));
    [row, col, c] = size(image1);

    % Frame difference without alignement
    frameDifference = sum(sum(abs(image1(sp+1:end-sp,sp+1:end-sp,:) - image2(sp+1:end-sp,sp+1:end-sp,:))));
%     msg = sprintf('Frame difference before alignement: %d \n',frameDifference); disp(msg);

    % Apply Block Matching to the image
    % Swaping image1 and image2 you can swap between forward and backwar motion
    % estimation??? Also changing the direction of the resulting vectors????
    p = 16;
    blockSize = 20;
    %Compute motion using grayscale images
    [motion] = blockMathcing(mean(image1,3), mean(image2,3), blockSize, p);
    dX = motion(:,:,1);
    dY = motion(:,:,2);

    %Compute mean motion
    meandX = round(mean(dX(:))) + formerMeandX;
    meandY = round(mean(dY(:))) + formerMeandY;

    disp(meandX)
    disp(meandY)
    
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
        disp('X Motion bigger than stab ilization pixels');
    end
    if meandY < -sp
        meandY = -sp;
        disp('Y Motion bigger than stabilization pixels');
    end

    %Crop image1
    newImage1 = image1(sp+1:end-sp,sp+1:end-sp,:);
    
    %Crop image2 taking into account motion
    newImage2 = image2(sp+1+meandY:end-sp+meandY,sp+1+meandX:end-sp+meandX,:);


    % Frame difference affter alignement
    frameDifference = sum(sum(abs(newImage1 - newImage2)));
%     msg = sprintf('Frame difference affter alignement: %d \n',frameDifference); disp(msg);

    formerMeandX = meandX;
    formerMeandY = meandY;

    %Save images
    name1 = strsplit(files{i},'/');
    name2 = strsplit(files{i+1},'/');
    imwrite(uint8(newImage1),name1{4});
    imwrite(uint8(newImage2),name2{4});
end



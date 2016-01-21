clear all; close all; dbstop error;

addpath('devkit_Stereo_flow\devkit\matlab\');

% KITTY

p_values = 8:8:40;
p_values = [32];
blockSize_values = 20:10:60;
blockSize_values = [60];
%imagesID_values = {'000157'; '000045'};
imagesID_values = {'000045'};

%motionType_values = {'forward', 'backward'};
motionType_values = {'backward'};

for m=1:length(motionType_values)
    motionType = motionType_values{m};
    disp(motionType);
for k=1:length(imagesID_values)
    imageId = imagesID_values(k);

    path = strcat('data_stereo_flow\training\image_0\',imageId,'_10.png');
    image_10 = double(imread(path{1}));
    path = strcat('data_stereo_flow\training\image_0\',imageId,'_11.png');
    image_11 = double(imread(path{1}));

    [row, col] = size(image_10);

    % Load the Kitty ground truth for the image
    path = strcat('data_stereo_flow\training\flow_noc\',imageId,'_10.png');
    F_gt  = flow_read(path{1});

    msg = sprintf('Image -> %s', imageId{1});
    disp(msg);
    
for j=1:length(blockSize_values)
for i=1:length(p_values)


    % Apply Block Matching to the image
    % Swaping image1 and image2 you can swap between forward and backwar motion
    % estimation??? Also changing the direction of the resulting vectors????
    % p = 8;
    % blockSize = 20;

    p = p_values(i);
    blockSize = blockSize_values(j);
    msg = sprintf('BlockSize=%d  AreaOfSearch=%d', blockSize, p);
    disp(msg);

    [motion] = blockMathcing(image_10, image_11, blockSize, p);%, motionType);
    dX = motion(:,:,1);
    dY = motion(:,:,2);

    % Plot the result of applying block mathcing to the image
    % Plotting 1 motion vector per block
    [X,Y] = meshgrid(1:blockSize:col, 1:blockSize:row);
    
    im = uint8(image_10);
    
%     figure('Name','','Visible','off');
%     xlabel(''); ylabel(''); title('');
%     axis([0,col,0,row]);
%     imshow(im); hold;
%     
%     q = quiver(X, Y, dX(1:blockSize/3:row, 1:blockSize/3:col), dY(1:blockSize/3:row, 1:blockSize/3:col));
%     q.AutoScaleFactor = 1;
%     set(q,'linewidth',1);
%     set(q,'color',[1,0,0]);
    
%     filename = sprintf('../../output/image_%s_%s_%s',num2str(blockSize),num2str(p),motionType);
%     print(gcf, '-dpng', filename);
    
    % Number of valid coordinates of the groundtruth
    numValidPixels = sum(sum(F_gt(:,:,3)));

    % Consider a fail if the magnitude is greater than TAU
    tau = 3;

    % Compute metrics for our block matching implementation
    error_magnitude_1 = sqrt( ( motion(:,:,1) - F_gt(:,:,1) ).^2 + ( motion(:,:,2) - F_gt(:,:,2) ).^2 ) .* F_gt(:,:,3);
    MMEN_1(blockSize, p) = sum(error_magnitude_1(:))/numValidPixels;
    PEPN_1(blockSize, p) = sum(error_magnitude_1(:) > tau)/ numValidPixels;

    msg = sprintf('Block Matching : MMEN=%.3f PEPN=%.3f\n', MMEN_1(blockSize, p), PEPN_1(blockSize, p)*100);
    disp(msg);

end
end
  
end
end


% Load the result of applying Lukas Kanade to the image
path = strcat('results_opticalflow_kitti\results\LKflow_',imageId,'_10.png');
F_est = flow_read(path{1});

% Compute meetrics for Lukas Kanade
error_magnitude_2 = sqrt( ( F_est(:,:,1) - F_gt(:,:,1) ).^2 + ( F_est(:,:,2) - F_gt(:,:,2) ).^2 ) .* F_gt(:,:,3);
MMEN_2 = sum(error_magnitude_2(:))/numValidPixels;
PEPN_2 =  sum(error_magnitude_2(:) > tau)/ numValidPixels;

msg = sprintf('Lukas Kanade : MMEN=%.3f PEPN=%.3f', MMEN_2, PEPN_2*100);
disp(msg);
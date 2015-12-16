%
% WEEK 1 -> Task 2
%

% Path to place generated images
DirOUT = 'output/';

% Path to Dataset Images
DirDS = 'dataset/baseline/highway/input/';
% Path to images from dataset
DirGT = 'dataset/baseline/highway/groundtruth/';
% Path to the results of Test A
DirTA = 'results_testAB_changedetection/testA/';
% Path to the results of Test B
DirTB = 'results_testAB_changedetection/testB/';
% Load a list of the files within the folders
ImDS = ListFiles( DirDS );
ImGT = ListFiles( DirGT );
ImTA = ListFiles( DirTA );
ImTB = ListFiles( DirTB );
% Count the number of files
NumDS = numel(ImDS);
NumGT = numel(ImGT);
NumTA = numel(ImTA);
NumTB = numel(ImTB);

% Print Info
Message = sprintf('Number of images in Dataset : %d', NumDS);
disp(Message);
Message = sprintf('Number of images in Test A : %d', NumTA);
disp(Message);
Message = sprintf('Number of images in Test B : %d', NumTB);
disp(Message);
Message = sprintf('Number of images in Groundtruth : %d', NumGT);
disp(Message);
disp('');
disp('');

% Initialize Metric Variables
A_TP = 0; A_FP = 0; A_FN = 0; A_TN = 0;
B_TP = 0; B_FP = 0; B_FN = 0; B_TN = 0;


for index=1:size(ImGT,1)
    Message = sprintf('Image : %s : %d / %d', ImGT(index).name, index, NumGT);
    disp(Message);
    
    % Load frames
    im = double(imread(strcat(DirDS,ImDS(index).name)))/255;
    im_gt = double(imread(strcat(DirGT,ImGT(index).name)))/255;
    im_ta = double(imread(strcat(DirTA,ImTA(index).name)));
    im_tb = double(imread(strcat(DirTB,ImTB(index).name)));

    fig = figure('Name','Name_Value','Visible','off');

    % Plot Dataset image
    subplot(2, 2, 1); imshow(im); title('Image');
    % Plot test A
    subplot(2, 2, 2); imshow(im_gt); title('Ground Truth');
    % Plot Test A Results
    subplot(2, 2, 3); imshow(im_ta); title('Test A');
    % Plot Test B Results
    subplot(2, 2, 4); imshow(im_tb); title('Test B');
    % Save figure to disk
    print(gcf, '-dpng', strcat(DirOUT, ImGT(index).name));
end

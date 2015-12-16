% Path to place generated images
DirOUT = 'output/';

% Path to Dataset Images
DirDS = 'highway/input/';
% Path to images from dataset
DirGT = 'highway/groundtruth/';
% Path to the results of the tests
DirTATB = 'results/';

% Load a list of the files within the folders
ImDS = ListFiles( DirDS );
ImGT = ListFiles( DirGT );
ImTATB = ListFiles( DirTATB );

% Count the number of files
NumDS = numel(ImDS);
NumGT = numel(ImGT);
NumTATB = numel(ImTATB);

%% Obtain filenames
ImTA = [];
ImTB = [];
for i = 1:NumTATB
    name = ImTATB(i).name;
    if strncmp('test_A', name, 6) == 1
        ImTA = [ImTA; cellstr(name)];
    end
    if strncmp('test_B', name, 6) == 1
        ImTB = [ImTB; cellstr(name)];
    end
end

NumTA = numel(ImTA);
NumTB = numel(ImTB);
%%

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


for index=1:size(ImTA,1)
    Message = sprintf('Image : %s : %d / %d', ImGT(index).name, index, NumGT);
    disp(Message);
    
    % Load frames
    im = double(imread(strcat(DirDS,ImDS(index+1200).name)))/255;
    im_gt = double(imread(strcat(DirGT,ImGT(index+1200).name)))/255;
    im_ta = double(imread(strcat(DirTATB,char(ImTA(index)))));
    im_tb = double(imread(strcat(DirTATB,char(ImTB(index)))));

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

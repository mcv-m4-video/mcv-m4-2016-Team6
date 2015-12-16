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
Message = sprintf('Number of images in TA : %d',NumTA);
disp(Message);
Message = sprintf('Number of images in TB : %d',NumTB);
disp(Message);
Message = sprintf('Number of images in GT : %d',NumGT);
disp(Message);


for off=1:25

for index=1+off:size(ImTA,1)
    
    % Read frames
    im = double(imread(strcat(DirDS,ImDS(index+1200).name)))/255;
    im_gt = double(imread(strcat(DirGT,ImGT(index+1200-off).name)))/255;
    im_ta = double(imread(strcat(DirTATB,char(ImTA(index)))));
    im_tb = double(imread(strcat(DirTATB,char(ImTB(index)))));
    
    % Perform comparison between test A and ground truth
    [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(im_ta, im_gt);
    A_TP = pixelTP;    A_FP = pixelFP;
    A_FN = pixelFN;    A_TN = pixelTN;
    
    % Perform comparison between test B and ground truth
    [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(im_tb, im_gt);
    B_TP = pixelTP;    B_FP = pixelFP;
    B_FN = pixelFN;    B_TN = pixelTN;    
    
    % Print info
    Message = sprintf('Image : %s : %d / %d', ImGT(index).name, index, NumGT); disp(Message);
    Message = sprintf('Test A : F1 = %f', A_F1); disp(Message);
    Message = sprintf('Test B : F1 = %f', B_F1); disp(Message);
end

% Evaluation on test A performance
[~,~, ~, ~, A_F1] = PerformanceEvaluationPixel(A_TP, A_FP, A_FN, A_TN);
A_F1_vec(off) = A_F1;

% Evaluation on test B performance
[~,~, ~, ~, B_F1] = PerformanceEvaluationPixel(B_TP, B_FP, B_FN, B_TN);
B_F1_vec(off) = B_F1;


end

x = 1:1:25;

% Plot F1 Score vs #Frame
fig1 = figure('Name','Add a Name','Visible','off');
plot(x, A_F1_vec, 'b', x, B_F1_vec, 'r');
title('F1-Score'); xlabel('Offset'); ylabel('F1-Score')
legend('Test A','Test B');
print(gcf, '-dpng', 'F1_vs_Offset');
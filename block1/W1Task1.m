%
% WEEK 1 -> Task 1
%

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
Message = sprintf('Number of images in TA : %d',NumTA);
disp(Message);
Message = sprintf('Number of images in TB : %d',NumTB);
disp(Message);
Message = sprintf('Number of images in GT : %d',NumGT);
disp(Message);

% Initialize Metric Variables
A_TP = 0; A_FP = 0; A_FN = 0; A_TN = 0;
B_TP = 0; B_FP = 0; B_FN = 0; B_TN = 0;

for index=1:size(ImGT,1)
    % Load frames
    im = double(imread(strcat(DirDS,ImDS(index).name)))/255;
    im_gt = double(imread(strcat(DirGT,ImGT(index).name)))/255;
    im_ta = double(imread(strcat(DirTA,ImTA(index).name)));
    im_tb = double(imread(strcat(DirTB,ImTB(index).name)));
    
    % Perform comparison between test A and ground truth
    [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(im_ta, im_gt);
    A_TP = A_TP + pixelTP;    A_FP = A_FP + pixelFP;
    A_FN = A_FN + pixelFN;    A_TN = A_TN + pixelTN;
    
    % Perform comparison between test B and ground truth
    [pixelTP, pixelFP, pixelFN, pixelTN] = PerformanceAccumulationPixel(im_tb, im_gt);
    B_TP = B_TP + pixelTP;    B_FP = B_FP + pixelFP;
    B_FN = B_FN + pixelFN;    B_TN = B_TN + pixelTN;
end


% Evaluation on test A performance
[A_Pre, A_Rec, A_Spe, A_Sen, A_F1] = PerformanceEvaluationPixel(A_TP, A_FP, A_FN, A_TN);

% Evaluation on test B performance
[B_Pre, B_Rec, B_Spe, B_Sen, B_F1] = PerformanceEvaluationPixel(B_TP, B_FP, B_FN, B_TN);

% Show all results
PixAccumEval = [A_TP, A_FP, A_FN, A_TN; B_TP, B_FP, B_FN, B_TN];
YAxis = 'Test_A Test_B';
XAxis = 'TP  FP  FN  TN';
printmat(PixAccumEval,'Pixel Accumulation',YAxis, XAxis);

PixPerfEval = [A_Pre, A_Rec, A_Spe, A_Sen, A_F1 ; B_Pre, B_Rec, B_Spe, B_Sen, B_F1];
YAxis = 'Test_A Test_B';
XAxis = 'Pre  Rec  Spe  Sen F1';
printmat(PixPerfEval,'Pixel Performance',YAxis, XAxis);

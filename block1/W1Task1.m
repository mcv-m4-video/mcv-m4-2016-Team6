% Path to images from dataset
DirGT = 'highway/groundtruth/';
% Path to the results of the tests
DirTATB = 'results_testAB/';

% Load a list of the files within the folders
ImGT = ListFiles( DirGT );
ImTATB = ListFiles( DirTATB );

% Count the number of files
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

% Initialize Metric Variables
A_TP = 0; A_FP = 0; A_FN = 0; A_TN = 0;
B_TP = 0; B_FP = 0; B_FN = 0; B_TN = 0;

for index=1:size(ImTA,1)
    % Load frames
    im_gt = double(imread(strcat(DirGT,ImGT(index+1200).name)))/255;
    im_ta = double(imread(strcat(DirTATB,char(ImTA(index)))));
    im_tb = double(imread(strcat(DirTATB,char(ImTB(index)))));
    
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
[A_Pre, A_Rec, ~, ~, A_F1] = PerformanceEvaluationPixel(A_TP, A_FP, A_FN, A_TN);

% Evaluation on test B performance
[B_Pre, B_Rec, ~, ~, B_F1] = PerformanceEvaluationPixel(B_TP, B_FP, B_FN, B_TN);

% Show all results
PixAccumEval = [A_FN, A_TN, A_FP, A_TP; B_FN, B_TN, B_FP, B_TP];
YAxis = 'Test_A Test_B';
XAxis = 'FN  TN  FP  TP';
printmat(PixAccumEval,'Pixel Accumulation',YAxis, XAxis);

PixPerfEval = [A_Pre, A_Rec, A_F1 ; B_Pre, B_Rec, B_F1];
YAxis = 'Test_A Test_B';
XAxis = 'Pre  Rec  F1';
printmat(PixPerfEval,'Pixel Performance',YAxis, XAxis);

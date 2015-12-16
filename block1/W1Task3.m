% Path to Dataset Images
DirDS = 'highway/input/';
% Load images from dataset
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

% Initialize variables to store frame by frame data
A_F1_Frames = []; B_F1_Frames = [];     % F1-Score frame by frame, both test A and B
A_TP_Frames = []; B_TP_Frames = [];     % True Positives pixels frame by frame, both test A and B
FG_Frames = [];                         % Foreground pixels frame by frame, both test A and B

for index=1:size(ImTA,1)
    % Read frames
    im_gt = double(imread(strcat(DirGT,ImGT(index+1200).name)))/255;
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
    
    % Obtain F1 measure from test A
    [~, ~, ~, ~, A_F1] = PerformanceEvaluationPixel(A_TP, A_FP, A_FN, A_TN);
    A_F1_Frames = [A_F1_Frames; A_F1];
    % Obtain F1 measure from test B
    [~, ~, ~, ~, B_F1] = PerformanceEvaluationPixel(B_TP, B_FP, B_FN, B_TN);
    B_F1_Frames = [B_F1_Frames; B_F1];
        
    % Foreground number of pixels fr the current frame
    FG = sum(sum(im_gt>0));
    FG_Frames = [FG_Frames; FG];
    % True Positives of test A
    A_TP_Frames = [A_TP_Frames; A_TP];
    % True Positives of test B
    B_TP_Frames = [B_TP_Frames; B_TP];
    
    % Print info
    Message = sprintf('Image : %s : %d / %d', ImGT(index).name, index, NumGT); disp(Message);
    Message = sprintf('Test A : F1 = %f , TP = %d, FG = %d', A_F1, A_TP, FG); disp(Message);
    Message = sprintf('Test B : F1 = %f , TP = %d, FG = %d', B_F1, B_TP, FG); disp(Message);
end


% Plot F1 Score vs #Frame
fig1 = figure('Name','Add a Name','Visible','on');
plot(1201:1400, A_F1_Frames, 'b', 1201:1400, B_F1_Frames, 'r');
title('F1-Score vs #Frames'); xlabel('#Frames'); ylabel('F1-Score')
legend('Test A','Test B');

% Plot True Positives vs Foreground (pixels)
%fig2 = figure('Name','Figure Name','Visible','on');
%plot(1201:1400, A_TP_Frames, 'b', 1201:1400, B_TP_Frames, 'r', 1201:1400, FG_Frames, 'g');
%title('title'); xlabel('xlabel'); ylabel('ylabel')
%legend('TestA : TP','TestB : TP', 'Foreground');

% Plot True Positives vs Foreground (pixels)
fig3 = figure('Name','Figure Name','Visible','on');
plot(1201:1400, A_TP_Frames./FG_Frames, 'b', 1201:1400, B_TP_Frames./FG_Frames, 'r');
title('title'); xlabel('xlabel'); ylabel('ylabel')
legend('TestA','TestB');
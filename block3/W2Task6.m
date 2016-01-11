% Initialization of workspace
clear all; close all; dbstop error;


%% Used to find the best LearningRate and MinimumBackgroundRate values for each dataset (it takes about 15 minutes)
% minBkgRatio = [0.5:0.1:0.9];
% learningRate = [0.002:0.003:0.015];

%Compute AUC with this
numGaussians = [3, 4, 5, 6];

%% HIGHWAY Dataset
%
disp('HIGHWAY Dataset')
% Paths
DirOUT = 'output/highway/';
DirDS = '../dataSet/highway/input/';
DirGT = '../dataSet/highway/groundtruth/';

% Best values founded
minBkgRatio = [0.5];
learningRate = [0.011];

% Frame sequence
seqIni = 1050;
seqFini = 1350;

for j=1:numel(numGaussians)
    %(TASK 0) Only S&G -AUC with different num of Gaussians-
%     [hw_pre(j), hw_rec(j), hw_f1(j)] = StaufferGrimson(DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians(j), minBkgRatio, learningRate);
    %(TASK 0+1) S&G + fill holes -AUC with different num of Gaussians-
%     [hw_pre(j), hw_rec(j), hw_f1(j)] = W3Task1(DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians(j), minBkgRatio, learningRate);
end

 %(TASK 0+1+2) S&G + fill holes + area filtering -AUC with different num of minPixels pixels per conected component
 numGaussians = 3;
 minPixels = 2:2:20;
for j=1:numel(minPixels)
    [hw_pre(j), hw_rec(j), hw_f1(j)] = W3Task2(minPixels(j), DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians, minBkgRatio, learningRate);
end


% AUC
%Compute area under the Precicion-Recall Curve
hw_AUC = trapz(hw_pre,hw_rec);

%% FALL Dataset
%
disp('FALL Dataset')
% Paths
DirOUT = 'output/fall/';
DirDS = '../dataSet/fall/input/';
DirGT = '../dataSet/fall/groundtruth/';

% Best values founded
minBkgRatio = [0.7];
learningRate = [0.014];

% Frame sequence
seqIni = 1460;
seqFini = 1560;

for j=1:numel(numGaussians)
    %(TASK 0) Only S&G -AUC with different num of Gaussians-
%     [fall_pre(j), fall_rec(j), fall_f1(j)] = StaufferGrimson(DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians(j), minBkgRatio, learningRate);
    %(TASK 0+1) S&G + fill holes -AUC with different num of Gaussians-
%     [fall_pre(j), fall_rec(j), fall_f1(j)] = W3Task1(DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians(j), minBkgRatio, learningRate);
end

 %(TASK 0+1+2) S&G + fill holes + area filtering -AUC with different num of minPixels pixels per conected component
 numGaussians = 3;
 minPixels = 2:2:20;
for j=1:numel(minPixels)
    [fall_pre(j), fall_rec(j), fall_f1(j)] = W3Task2(minPixels(j), DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians, minBkgRatio, learningRate);
end


% AUC
%Compute area under the Precicion-Recall Curve
fall_AUC = trapz(fall_pre,fall_rec)

%% TRAFFIC Dataset
%
disp('TRAFFIC Dataset');
% Paths
DirOUT = 'output/traffic/';
DirDS = '../dataSet/traffic/input/';
DirGT = '../dataSet/traffic/groundtruth/';

% Best values founded
minBkgRatio = [0.7];
learningRate = [0.014];

% Frame sequence
seqIni = 950;
seqFini = 1050;


for j=1:numel(numGaussians)
    %(TASK 0) Only S&G -AUC with different num of Gaussians-
%     [tff_pre(j), tff_rec(j), tff_f1(j)] = StaufferGrimson(DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians(j), minBkgRatio, learningRate);
    %(TASK 0+1) S&G + fill holes -AUC with different num of Gaussians-
%     [tff_pre(j), tff_rec(j), tff_f1(j)] = W3Task1(DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians(j), minBkgRatio, learningRate);
end

 %(TASK 0+1+2) S&G + fill holes + area filtering -AUC with different num of minPixels pixels per conected component
 numGaussians = 3;
 minPixels = 2:2:20;
for j=1:numel(minPixels)
    [tff_pre(j), tff_rec(j), tff_f1(j)] = W3Task2(minPixels(j), DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians, minBkgRatio, learningRate);
end



% AUC
%Compute area under the Precicion-Recall Curve
tff_AUC = trapz(tff_pre,tff_rec);

%% Plot results

%Precision vs recall
figure;
plot(hw_rec,hw_pre,'r',fall_rec,fall_pre,'g',tff_rec,tff_pre,'b');
legend(['highway', 'fall', 'traffic']);
xlabel('Recall');
ylabel('Precision');

%Plot AUC
AUCS = [hw_AUC, fall_AUC, tff_AUC];
bar(AUCS);
legend = (['highway', 'fall', 'traffic']);
ylabel('AUC');



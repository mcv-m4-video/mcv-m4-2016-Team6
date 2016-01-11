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
%     [hw_pre(j), hw_rec(j), hw_f1(i,k,j)] = StaufferGrimson(DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians(j), minBkgRatio, learningRate);
    %(TASK 0+1) S&G + fill holes -AUC with different num of Gaussians-
%     [hw_pre(j), hw_rec(j), hw_f1(1,1,j)] = W3Task1(DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians(j), minBkgRatio, learningRate);
end

 %(TASK 0+1+2) S&G + fill holes + area filtering -AUC with different num of minPixels pixels per conected component
 numGaussians = 3;
 minPixels = 2:2:20;
for j=1:numel(minPixels)
    [hw_pre(j), hw_rec(j), hw_f1(1,1,j)] = W3Task2(minPixels(j), DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians, minBkgRatio, learningRate);
end

% Find the maximum f-1 score configuration
[i,k,j] = find(hw_f1==max(max(max(hw_f1))));
msg = sprintf('Best F1 score : %.3f (#Gauss = %d , MinBackgroundRatio = %.3f, LeraningRate = %.3f', hw_f1(i,k,j), numGaussians(j), minBkgRatio, learningRate);
disp(msg);

%Compute area under the Precicion-Recall Curve
hw_AUC = trapz(pre,rec);

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
%     [fall_pre(j), fall_rec(j), fall_f1(i,k,j)] = StaufferGrimson(DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians(j), minBkgRatio, learningRate);
    %(TASK 0+1) S&G + fill holes -AUC with different num of Gaussians-
%     [fall_pre(j), fall_rec(j), fall_f1(1,1,j)] = W3Task1(DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians(j), minBkgRatio, learningRate);
end

 %(TASK 0+1+2) S&G + fill holes + area filtering -AUC with different num of minPixels pixels per conected component
 numGaussians = 3;
 minPixels = 2:2:20;
for j=1:numel(minPixels)
    [fall_pre(j), fall_rec(j), fall_f1(1,1,j)] = W3Task2(minPixels(j), DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians, minBkgRatio, learningRate);
end

% Find the maximum f-1 score configuration
[i,k,j] = find(fall_f1==max(max(max(fall_f1))));
msg = sprintf('Best F1 score : %.3f (#Gauss = %d , MinBackgroundRatio = %.3f, LeraningRate = %.3f', fall_f1(i,k,j), numGaussians(j), minBkgRatio(i), learningRate(k));
disp(msg);

%Compute area under the Precicion-Recall Curve
AUCFall = trapz(pre,rec);

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
%     [tff_pre(j), tff_rec(j), tff_f1(i,k,j)] = StaufferGrimson(DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians(j), minBkgRatio, learningRate);
    %(TASK 0+1) S&G + fill holes -AUC with different num of Gaussians-
%     [tff_pre(j), tff_rec(j), tff_f1(1,1,j)] = W3Task1(DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians(j), minBkgRatio, learningRate);
end

 %(TASK 0+1+2) S&G + fill holes + area filtering -AUC with different num of minPixels pixels per conected component
 numGaussians = 3;
 minPixels = 2:2:20;
for j=1:numel(minPixels)
    [tff_pre(j), tff_rec(j), tff_f1(1,1,j)] = W3Task2(minPixels(j), DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians, minBkgRatio, learningRate);
end



%% Find the maximum f-1 score configuration
[i,k,j] = find(tff_f1==max(max(max(tff_f1))));
msg = sprintf('Best F1 score : %.3f (#Gauss = %d , MinBackgroundRatio = %.3f, LeraningRate = %.3f', tff_f1(i,k,j), numGaussians(j), minBkgRatio(i), learningRate(k));
disp(msg);

%Compute area under the Precicion-Recall Curve
AUCTraffic = trapz(pre,rec);

%% Plot results


% Indices of the best results
% [i_hw,k_hw,j_hw] = find(hw_f1==max(max(max(hw_f1))));
% [i_fl,k_fl,j_fl] = find(fall_f1==max(max(max(fall_f1))));
% [i_tf,k_tf,j_tf] = find(tff_f1==max(max(max(tff_f1))));
% 
% hw_legend = sprintf('Highway (MinimunBackgroundRate=%.1f, LearningRate=%.3f)', minBkgRatio(i_hw), learningRate(k_hw));
% fl_legend = sprintf('Fall (MinimunBackgroundRate=%.1f, LearningRate=%.3f)', minBkgRatio(i_fl), learningRate(k_fl));
% tf_legend = sprintf('Traffic (MinimunBackgroundRate=%.1f, LearningRate=%.3f)', minBkgRatio(i_tf), learningRate(k_tf));
% 
% plot(numGaussians, reshape(hw_f1(i_hw,k_hw,:),1,4), '-bx', numGaussians, reshape(fall_f1(i_fl,k_fl,:),1,4), '-g^', numGaussians, reshape(tff_f1(i_tf,k_tf,:),1,4), '-ro');
% title('Number of Gaussians');
% legend(hw_legend,fl_legend,tf_legend);
% xlabel('#Gaussians'); ylabel('F1-Score');
% axis([3 6 0.3 1]);

%Precision vs recall
figure;
plot(hw_rec,hw_pre,'r',fall_rec,fall_pre,'g',tff_rec,tff_pre,'b');
legend(['highway', 'fall', 'traffic']);
xlabel('Recall');
ylabel('Precision');

%Display AUC
hw_AUC
fall_AUC
tff_AUC


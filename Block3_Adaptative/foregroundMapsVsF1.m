% Task 6: Foreground Maps
% Load the masks generated with Non recursive and recursive gaussian
% modelling, and are evaluated with the suggested by the paper, and the F1
% score

%% CONFIG
imagesID = 'highway';


%Already computed rhos (maybe bad approximation)
bestrho = 3; %Highway
% bestrho = 3.2; %Fall
% bestrho = 3.8; %Highway
    
disp(imagesID);


% Load Recursive Gaussian
alpha = 4;
filename = strcat(imagesID, '/', imagesID, '-alpha-', num2str(alpha), '.mat');
load(filename);

rec_gauss_masks = mask_images;

disp(['Start evaluation for... ' imagesID]);
imdir = '/secondhalf/';
[images, filenames, numImages] = LoadFrames(imagesID, imdir);


% Load Non Recursive Gaussian
[non_rec_gauss_masks] = ListNonRecursiveGaussian('results-highway\bestalpha\', numImages);


% Evaluates the two maps sequences with F1-score and Q
[Q_NonRec, F1_NonRec, Q_Rec, F1_Rec] = evaluateForegroundMaps( alpha, bestrho, images, non_rec_gauss_masks, rec_gauss_masks, filenames, imagesID, numImages);
    
X = [1:1:numImages];

figure('Name', 'Non Recursive Gaussian : F1-Measure vs Q');
plot(X,F1_NonRec,'r',X,Q_NonRec,'g');
title('Non Recursive Gaussian : F1-Measure vs Q');
legend('F1','Q')
xlabel('#Image');


figure('Name','Recursive Gaussian : F1-Measure vs Q');
plot(X,F1_Rec,'r',X,Q_Rec,'g');
title('Recursive Gaussian : F1-Measure vs Q');
legend('F1','Q')
xlabel('#Image');


figure('Name', 'Q : Non Recursive vs Recursive Gaussian');
plot(X,Q_NonRec,'r',X,Q_Rec,'g');
title('Q : Non Recursive vs Recursive Gaussian');
legend('Q Non Recursive','Q Recursive')
xlabel('#Image');
ylabel('Q');

figure('Name', 'F1 : Non Recursive Gaussian');
plot(X,F1_NonRec,'r',X,F1_Rec,'g');
title('Non Recursive Gaussian : F1-Measure vs Q');
legend('F1 Non Recursive','F1 Recursive')
xlabel('#Image');
ylabel('F1');

%Task 2 & 3: Evaluate results
clc
clear all
close all

% step2evaluate = '/'; %Only clasification
% step2evaluate = '/fillHoles/'; %Task 1
step2evaluate = '/reconstruction/4/'; %Task 2


imagesID = {'highway', 'fall', 'traffic'};

for type=1:length(imagesID)
    directory = [imagesID{type} +'/secondhalf/'];
    imagesData = ListFiles(directory);

    % Count the number of files
    numImages = numel(imagesData);

    % Load filenames
    filenames = [];
    for i = 1:numImages
        name = imagesData(i);
        filenames = [filenames; cellstr(name)];
    end

    %For each alpha load data and compare with annotations
    gtpath = [imagesID{type} +'/gt_evaluation.mat'];
    load(gtpath);
    for alpha=1:10
        pixelTP = 0; pixelTN = 0; pixelFP = 0; pixelFN = 0;
        filename = strcat(imagesID{type}, step2evaluate, imagesID{type}, '-alpha-', num2str(alpha), '.mat');
        load(filename);
        for i=1:numImages
            curImage = mask_images{i};
            cdata = gt_evaluation{i,1};
            % For every background pixel... 255, 170, 85, 50, 0
            [fil, col] = size(cdata);
            for fil=1:fil
                for col=1:col
                    if cdata(fil, col) > 50 && cdata(fil, col) < 255 %Not evaluated 
                    elseif cdata(fil, col) <= 50 && curImage(fil, col) == 0 %TN (BG)
                           pixelTN = pixelTN + 1;
                    elseif cdata(fil, col) == 255 && curImage(fil, col) > 0 %TP (FG)
                           pixelTP = pixelTP + 1;
                    elseif cdata(fil, col) <= 50  %FP 
                           pixelFP = pixelFP + 1;
                    else %FN
                          pixelFN = pixelFN + 1;
                    end
                end
            end
        end

        pixelPrecision   = pixelTP / (pixelTP+pixelFP);
        pixelSensitivity = pixelTP / (pixelTP+pixelFN);
        pixelF1          = (2*pixelTP) / (2*pixelTP + pixelFP + pixelFN);
        results{type,alpha} = {pixelTP, pixelTN, pixelFP, pixelFN,pixelPrecision,pixelSensitivity,pixelF1};
    end
end

%% Plot the results for all types
for type=1:length(imagesID)
    for i=1:alpha
        TP(type,i) = results{type,i}{1,1};
        TN(type,i) = results{type,i}{1,2};
        FP(type,i) = results{type,i}{1,3};
        FN(type,i) = results{type,i}{1,4};
        P(type,i) = results{type,i}{1,5};
        R(type,i) = results{type,i}{1,6};
        F1(type,i) = results{type,i}{1,7};
    end
    
%     x=0:1:10;
%     figure;
%     plot(x,TP(type,:),'-bx',x,TN(type,:),'-g^',x,FP(type,:),'-ro',x,FN(type,:),'-y*');
%     legend('TP','TN','FP','FN');
%     title(imagesID(type));
%     xlabel('Alpha');
%     ylabel('Pixels');

end


%F1 score
% figure;
% plot(x,F1(1,:),'r',x,F1(2,:),'g',x,F1(3,:),'b');
% legend([imagesID(1), imagesID(2), imagesID(3)]);
% xlabel('Alpha');
% ylabel('F1 score');

%Precision vs recall
figure;
plot(R(1,:),P(1,:),'r',R(2,:),P(2,:),'g',R(3,:),P(3,:),'b');
legend([imagesID(1), imagesID(2), imagesID(3)]);
xlabel('Recall');
ylabel('Precision');

%Area under Precision vs recall curve
hw_AUC = trapz(P(1,:),R(1,:));
fall_AUC = trapz(P(2,:),R(2,:));
tff_AUC = trapz(P(3,:),R(3,:));
mean_AUC = (hw_AUC + fall_AUC + tff_AUC) / 3;

disp(['AUC Highway: ' num2str(hw_AUC)]);
disp(['AUC Fall: ' num2str(fall_AUC)]);
disp(['AUC Traffic: ' num2str(tff_AUC)]);

figure;
AUCS = [hw_AUC, fall_AUC, tff_AUC, mean_AUC];
str = {'Highway'; 'Fall'; 'Traffic'; 'Mean'};
x=[1:1:4]';
bar(x,AUCS);
ylabel('AUC');
set(gca, 'XTickLabel',str, 'XTick',1:numel(str))
for i1=1:numel(AUCS)
    text(x(i1),AUCS(i1),num2str(AUCS(i1),'%0.2f'),...
               'HorizontalAlignment','center',...
               'VerticalAlignment','bottom')
end
ylim([0 1])

% ROC 
% figure;
% plot(FP(1,:),TP(1,:),'r',FP(2,:),TP(2,:),'g',FP(3,:),TP(3,:),'b');
% legend([imagesID(1), imagesID(2), imagesID(3)]);
% title('ROC');


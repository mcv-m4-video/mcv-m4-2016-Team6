% Compute Task 7 taking the f-1 scores obtained in Single Gaussian and
% Stauffer&Grisom for each dataset
y = [ 0.42 0.77; 0.72 0.64; 0.54 0.60];
bar(y);
legend('Single Gaussian', 'St&Gm');
ylabel('f1 score');
set(gca, 'XTickLabel', {'HIGHWAY';'FALL';'TRAFFIC'});
axis([0.5 3.5 0 1]);
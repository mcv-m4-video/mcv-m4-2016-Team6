function SaveResults( bestparam, imagesID, numImages)
%SAVERESULTS 
% rec = string 'rec' for recursive or 'nonrec' for non recursive
% param = string 'alpha' or 'rho' indicating parameter currently being
% varied

paramindex = bestparam/0.05;

filename = strcat(imagesID, '/', imagesID, '-result', '.mat');
load(filename);

resultsdir = ['results-' imagesID];
mkdir(resultsdir);

for i=1:numImages
    imwrite(mask_images{i}, strcat(resultsdir, '/im-', num2str(i), '-res.jpg') );
end


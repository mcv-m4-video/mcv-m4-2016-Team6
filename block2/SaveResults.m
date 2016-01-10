function SaveResults( bestparam, imagesID, numImages, rec, param)
%SAVERESULTS 
% rec = string 'rec' for recursive or 'nonrec' for non recursive
% param = string 'alpha' or 'rho' indicating parameter currently being
% varied

paramindex = bestparam/0.2;

filename = strcat(imagesID, '/', imagesID, '-', param, '-', num2str(paramindex+1), '.mat');
load(filename);

resultsdir = ['results-' imagesID];
mkdir(resultsdir);

for i=1:numImages
    imwrite(mask_images{i}, strcat(resultsdir, '/im-', num2str(i), rec, '-res.jpg') );
end


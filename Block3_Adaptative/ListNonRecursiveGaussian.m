function [files] = ListNonRecursiveGaussian(directory, N)
% Load the generated masks by non recursive gaussian modelling in Week 2
    f = dir(directory);
    for i=1:N
        filename = strcat(directory, 'im-', num2str(i), 'nonrec-res.jpg');
        files{i} = double(imread(filename));
    end
end

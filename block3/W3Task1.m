function [pre, rec, f1] = W3Task1(DirDS, DirGT, DirOUT, seqIni, seqFini, numGaussians, minBkgRatio, learningRate)
%StaufferGrimson + FillHoles
connectivity = 4; %4, 8

 disp(DirDS)
    % Load a list of the files within the folders
    [imDS, numDS] = ListFiles( DirDS );
    [imGT, numGT] = ListFiles( DirGT );

    %
    N = seqFini - seqIni + 1;

    % Pixel acumulation performance
    tp = zeros(1, N); fp = zeros(1, N);
    tn = zeros(1, N); fn = zeros(1, N);

    numTrainingFrames = floor((seqFini - seqIni)/2);

    % Grimson & Stauffer detector (Matlab implementation)
    detector = vision.ForegroundDetector(...
                                'NumTrainingFrames', numTrainingFrames, ...
                                'AdaptLearningRate', true, ...
                                'LearningRate', learningRate, ...
                                'InitialVariance', 'Auto', ...                                
                                'NumGaussians', numGaussians, ...
                                'MinimumBackgroundRatio', minBkgRatio);


    % For each image to be processed
    for i=seqIni:seqFini
        % Load frame to process
        im = rgb2gray(imread(imDS{i}));
        % Load ground truth
        im_gt = imread(imGT{i});
        im_gt(im_gt<51) = 0;
        im_gt(im_gt>50) = 255;

        % Compute St & Gr (Task0)
        fgMask = step(detector, im);

        %Filling holes  (Task1)
        fgMask = imfill(fgMask, connectivity, 'holes');
        
        % Test Images
        if i > seqIni + numTrainingFrames

            msg = sprintf('[test #gauss=%d] %s\n', numGaussians, imDS{i});
            % disp(msg);
            % Pixel evaluation
            [tp(i), fp(i), fn(i), tn(i)] = PerformanceAccumulationPixel(fgMask, im_gt);
            msg = sprintf('\ttp=%d\t\tfp=%d\t\tfn=%d\t\ttn=%d', tp(i), fp(i), fn(i), tn(i));

                 disp(msg);
                % Save Foreground estimation to disk
%                 fig = figure('Name','Name_Value','Visible','off');
%                 subplot(1, 3, 1); imshow(uint8(im)); title('Image');
%                 subplot(1, 3, 2); imshow(fgMask); title('St&Gr');
%                 subplot(1, 3, 3); imshow(im_gt); title('Ground Truth');
                
                %Save only the estimation
%                 name = sprintf('%d_gauss_%d.png', i, numGaussians);
%                 fullname = [DirOUT name];
%                 disp(name)
%                 imwrite(fgMask, fullname);

        % Train Images
        else
           msg = sprintf('[train #gauss=%d] %s\n', numGaussians, imDS{i});
           % disp(msg);
        end
    end

    % Reset detector parameters
    reset(detector);

    % Compute metrics (for each #Gaussian)
    % pre = zeros(1, M); rec = zeros(1, M); f1 = zeros(1, M);
    [pre, ~, ~, rec, f1] = PerformanceEvaluationPixel(sum(tp(:)), sum(fp(:)), sum(fn(:)), sum(tn(:)));        

end


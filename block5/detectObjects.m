function [centroids, bboxes, mask] = detectObjects(frame,obj)

    % Detect foreground.
%     mask = obj.detector.step(frame);
    mask = mydetector(frame, bestalpha, bestrho, means, variances, sigmas);
    mask = logical(mask);

    
    % Apply morphological operations to remove noise and fill in holes.
    %open + close + imfill
%     mask = imopen(mask, strel('rectangle', [3,3]));
%     mask = imclose(mask, strel('rectangle', [15, 15])); 
%     mask = imfill(mask, 'holes');
    
    %imfill + reconstrucition by erosion
    mask = imfill(mask, 4, 'holes');
    marker = myerode(mask,ones(5,5));
    mask = reconstruct(mask, marker);

    % Perform blob analysis to find connected components.
    [~, centroids, bboxes] = obj.blobAnalyser.step(mask);
end


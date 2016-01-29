function [centroids, bboxes, mask] = detectObjects(frame, obj, bestalpha, bestrhos)

    % Detect foreground.
%     mask = obj.detector.step(frame);
    mask = mydetector(frame, bestalpha, bestrhos);
    mask = logical(mask);

    
    % Apply morphological operations to remove noise and fill in holes.
    %open + close + imfill
    mask = imopen(mask, strel('rectangle', [5,5]));
    mask = imclose(mask, strel('rectangle', [10, 10])); 
    mask = imfill(mask, 'holes');
    
    %imfill + reconstruction by erosion
%     mask = imfill(mask, 18, 'holes');
%     marker = myerode(mask,ones(5,5));
%     mask = reconstruct(mask, marker);

    % Perform blob analysis to find connected components.
    [~, centroids, bboxes] = obj.blobAnalyser.step(mask);
end


function tracks = displayTrackingResults(obj,tracks,frame,bboxes,mask)

global carCount

    % Convert the frame and the mask to uint8 RGB.
    frame = im2uint8(frame);
    mask = uint8(repmat(mask, [1, 1, 3])) .* 255;

    minVisibleCount = 8;
    if ~isempty(tracks)

        % Noisy detections tend to result in short-lived tracks.
        % Only display tracks that have been visible for more than 
        % a minimum number of frames.
        reliableTrackInds = ...
            [tracks(:).totalVisibleCount] > minVisibleCount;
        reliableTracks = tracks(reliableTrackInds);

        % Display the objects. If an object has not been detected
        % in this frame, display its predicted bounding box.
        if ~isempty(reliableTracks)
            % Get bounding boxes.
            bboxes = cat(1, reliableTracks.bbox);

            % Get ids.
%             disp(reliableTracks(:).id)
%             disp(reliableTracks(:).speed)
            labels = {};
            for i=1:length(reliableTracks)
               labels{i} = strcat([num2str(round(reliableTracks(i).id2print)), ' - ', num2str(round(reliableTracks(i).speed)) , 'km/h']);
            end
            
            % Create labels for objects indicating the ones for 
            % which we display the predicted rather than the actual 
            % location.
            predictedTrackInds = ...
                [reliableTracks(:).consecutiveInvisibleCount] > 0;
            isPredicted = cell(size(labels));
            isPredicted(predictedTrackInds) = {' predicted'};
            labels = strcat(labels, isPredicted);

            % Draw the objects on the frame.
            frame = insertObjectAnnotation(frame, 'rectangle', ...
                bboxes, labels);

            % Draw the objects on the mask.
            mask = insertObjectAnnotation(mask, 'rectangle', ...
                bboxes, labels);
        end
    end
    
%     global count
    % Display the mask and the frame.
    obj.maskPlayer.step(mask);        
    obj.videoPlayer.step(frame);
%     imwrite(frame,strcat('frame',num2str(count),'.jpg'));
%     imwrite(mask,strcat('mask',num2str(count),'.jpg'));
%     count = count +1;
    
end

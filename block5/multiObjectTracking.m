function multiObjectTracking(bestalpha, bestrho, means, variances, sigmas)

% Create System objects used for reading video, detecting moving objects,
% and displaying the results.
obj = setupSystemObjects();

tracks = initializeTracks(); % Create an empty array of tracks.

nextId = 1; % ID of the next track

% Detect moving objects, and track them across video frames.
while ~isDone(obj.reader)
    
    frame = readFrame(obj);
    
    [centroids, bboxes, mask] = detectObjects(frame, obj, bestalpha, bestrho, means, variances, sigmas);
    
    tracks = predictNewLocationsOfTracks(tracks);
    
    [assignments, unassignedTracks, unassignedDetections] = ...
        detectionToTrackAssignment(tracks,centroids);
    
    tracks = updateAssignedTracks(tracks,centroids,bboxes,assignments);
    
    tracks = updateUnassignedTracks(tracks,unassignedTracks);
    
    tracks = deleteLostTracks(tracks);
    
    [tracks,nextId] = createNewTracks(tracks,nextId,centroids,bboxes,unassignedDetections);
    
    displayTrackingResults(obj,tracks,frame,bboxes,mask);
end

end


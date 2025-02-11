function multiObjectTracking(bestalpha, bestrho)

% Create System objects used for reading video, detecting moving objects,
% and displaying the results.
disp('Tracking...')
obj = setupSystemObjects();

tracks = initializeTracks(); % Create an empty array of tracks.

nextId = 1; % ID of the next track

% Detect moving objects, and track them across video frames.
while ~isDone(obj.reader)
    
    frame = readFrame(obj);
    
    [centroids, bboxes, mask] = detectObjects(frame, obj, bestalpha, bestrho);
    
    tracks = predictNewLocationsOfTracks(tracks);
    
    [assignments, unassignedTracks, unassignedDetections] = ...
        detectionToTrackAssignment(tracks,centroids);
    
    tracks = updateAssignedTracks(tracks,centroids,bboxes,assignments);
    
    tracks = updateUnassignedTracks(tracks,unassignedTracks);
    
    tracks = deleteLostTracks(tracks);
    
    [tracks,nextId] = createNewTracks(tracks,nextId,centroids,bboxes,unassignedDetections);
    
    tracks = computeInstantSpeed(tracks);
    
    tracks = setId2Print(tracks);
    
    displayTrackingResults(obj,tracks,frame,bboxes,mask);
end

    %Save the data of the alive tracks
    computeAndStoreSpeed(tracks);
end


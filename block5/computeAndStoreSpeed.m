function [  ] = computeAndStoreSpeed( toDeleteTracks )
global distances
global times
%For every track that we are going to delete
for i = 1 : length(toDeleteTracks)
    if toDeleteTracks(i).totalVisibleCount < 10  %If the tracking was too short is a false detection
       continue
    end
    
    %Store num of frames the object has been in the scene
    times(end+1) = toDeleteTracks(i).totalVisibleCount;
   
    %Compute distance between the centroid when the object appeared and
    %when it dissapeared.
     xDist = abs(toDeleteTracks(i).curCentroid(1) - toDeleteTracks(i).initialCentroid(1));
     yDist = abs(toDeleteTracks(i).curCentroid(2) - toDeleteTracks(i).initialCentroid(2));
     distances(end+1) = round(sqrt(xDist^2 + yDist^2));
end


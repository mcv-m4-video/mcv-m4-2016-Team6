function [ tracks ] = computeInstantSpeed( tracks )
%Computes instant speed of each object comparing centrois in previous and
%current frame

    for i = 1:length(tracks)
        
    if tracks(i).totalVisibleCount < 2  %If the tracking was too short don't show speed
        tracks(i).speed = 0;
       continue
    end
    
    %TIME
    %Compute time spent per frame (20fps)
    time = 1/20;
   
    %DISTANCE
    %Compute distance between the centroid between current frame and previous
    %frame
     xDist = abs(tracks(i).curCentroid(1) - tracks(i).prevCentroid(1));
     yDist = abs(tracks(i).curCentroid(2) - tracks(i).prevCentroid(2));
     distance = round(sqrt(xDist^2 + yDist^2));  
     %Based on the mean length of the road lines in pixels (16px) and its
     %real length in meters (4.5m),
     pixels2meters = 4.5/16; 
     distance = distance * pixels2meters;
     tracks(i).speed = (distance/time) * 3.6;
    end

end


function [ tracks ] = setId2Print( tracks )
%Sets the ids to print using the car counter
global carCount
minVisibleCount = 8;
for i=1:length(tracks)
    if(tracks(i).totalVisibleCount > minVisibleCount)
       if tracks(i).id2print == 0
           carCount = carCount + 1;
           tracks(i).id2print = carCount;                 
       end
    end
end
end


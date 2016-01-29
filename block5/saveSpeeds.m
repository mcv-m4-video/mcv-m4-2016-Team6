function [  ] = saveSpeeds(  )
%Computes cars mean speed and saves it to a file.

%DISTANCE
%Based on the mean length of the road lines in pixels (16px) and its
%real length in meters (4.5m),

%TIME
%We are using 20fps videos so one frame in scene is 1/20'
global distances
global times

% pixels2meters = 4.5/16;
pixels2meters = 5/12;
frames2seconds = 1/20;
realDistances = distances * pixels2meters;
realTimes = times * frames2seconds;
speeds = (realDistances ./ realTimes).* 3.6;

fileID = fopen('speeds.txt','w');
fprintf(fileID,'%s %s %s\n','Distance(m)','Time(s)','Speed(Km/h)');
for i=1:length(speeds)
    fprintf(fileID,'%6.2f %6.2f %6.2f \n',realDistances(i),realTimes(i),speeds(i));
end
fclose(fileID);




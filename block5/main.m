%Global vars to compute speed
global distances
global times 
distances = [];
times = [];

%% RUN MULTITRACKING CODE
multiObjectTracking();

saveSpeeds(); %Saves speed data to 'speeds.txt' file
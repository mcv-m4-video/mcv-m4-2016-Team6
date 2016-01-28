%% OBTAIN NECESSARY FILES
% If input is video, obtain image sequence and vice versa


% imdir = 'highway/input'
% videofile = 'highway.avi'

%% INITIALIZATION
%Global vars to compute speed
global distances
global times 
distances = [];
times = [];

global means
global variances
global sigmas

%Variables to train sequence for background subtraction 
numFrames = 200; % TODO: apply this
imagesID = 'highway';
bestalpha = 2;
bestrho = 0.2;

[means, variances, sigmas] = initializeSegmentation(numFrames, imagesID);

%% RUN MULTITRACKING

multiObjectTracking(bestalpha, bestrho);

saveSpeeds(); %Saves speed data to 'speeds.txt' file
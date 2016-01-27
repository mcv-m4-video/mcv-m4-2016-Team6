
%find jpg in 'highway' folder
imageNames = dir(fullfile('highway', '*.jpg'));
imageNames = {imageNames.name}';

%construct videowriter object that creates motion-jpeg .avif ile

outputVideo = VideoWriter(fullfile('highway_extended_20fps.avi'));
outputVideo.FrameRate = 20;
open(outputVideo)

%loop through image sequence, load each image, and write to video
for ii = 1:length(imageNames)
    img = imread(fullfile('highway',imageNames{ii}));
    writeVideo(outputVideo,img)
end

close(outputVideo)


function multiDeepLearningTracking(bestalpha, bestrhos)



% Create System objects used for reading video, detecting moving objects,
% and displaying the results.
obj = setupDLTSystemObjects();

tracks = initializeDLTracks(); % Create an empty array of tracks.

doTrack = 1;
MUTEX = 0;
duration = 0; tic;
nextId = 1; % ID of the next track
nextFrame = 1;
% Detect moving objects, and track them across video frames.
while ~isDone(obj.reader)
    
   
    % Read next frame
    frame = readFrame();
    msg = sprintf('\n\n****************   FRAME ID = %d   ****************\n', nextFrame);
    disp(msg);    

    % Detect Objects in new frame
    [centroids, bboxes, mask] = detectObjects(frame, obj, bestalpha, bestrhos);     % Detector implemented in MCV_2016
%     [centroids, bboxes, mask] = objectDetector(frame);                              % Stauffer&Grimson Implementation

    msg = sprintf('OBJECTS DETECTED = %d\n', size(bboxes,1));
    disp(msg);
    
    if doTrack == 1
        % Update the already created tracks
        updatedTracks = updateAssignedTracks();
        msg = sprintf('TRACKS UPDATED = %d', updatedTracks);
        disp(msg);

        % Update the speed for already existing tracks
        updateInstantSpeed();
        
        % Assign a tracker to the non-tracked objects
        newTracks = detectUntrackedBBoxes();    
        msg = sprintf('NUMBER OF NEW TRACKS = %d', newTracks);
        disp(msg);

        % Deactive the tracks corresponding with objects out of the image
        deactivateOutOfImageTracks()    
    end
    
    % Render results
    displayDLTrackingResults();
    
    duration = duration + toc;
    msg = sprintf('%d FRAMES TOOK %.3f sec : FPS = %.3f\n',nextFrame,duration,nextFrame/duration);
    disp(msg);
    nextFrame = nextFrame + 1;
end




%% Find which BBoxes are out of image
    function deactivateOutOfImageTracks()
        if isempty(tracks)
            return;
        end

        updatedTracks = 0;
        for i = 1:size(tracks(:), 1)
            if(tracks(i).active == 1)
                bbox = tracks(i).bbox
                if(( bbox(1)<0 )|| (bbox(2)+bbox(4))>240)
                    tracks(i).active = 0;
                    msg = sprintf('\ttrack(%d) : [%.3f, %.3f, %.3f, %.3f]  -->  DEACTIVATED\n', i, ...
                                            bbox(1), bbox(2), bbox(3), bbox(4));
                    disp(msg);
                end
            end
        end
    end


%% Delete Lost Tracks
    function deleteLostTracks()
        if isempty(tracks)
            return;
        end
        
        invisibleForTooLong = 20;
        ageThreshold = 8;
        
        % Compute the fraction of the track's age for which it was visible.
        ages = [tracks(:).age];
        totalVisibleCounts = [tracks(:).totalVisibleCount];
        visibility = totalVisibleCounts ./ ages;
        
        % Find the indices of 'lost' tracks.
        lostInds = (ages < ageThreshold & visibility < 0.6) | ...
            [tracks(:).consecutiveInvisibleCount] >= invisibleForTooLong;
        
        % Delete lost tracks.
        tracks = tracks(~lostInds);
    end

%% Update Assigned Tracks
    % Correspondecia entre los nuevos BBoxes y los que estabamos trackenado
    function [updatedTracks] = updateAssignedTracks()

        updatedTracks = 0;
        for i = 1:size(tracks(:), 1)
            oldBbox = tracks(i).bbox;
            if(tracks(i).active == 1)
                
                [bbox, step_dlt] = Step_DLT(tracks(i).DLT, frame, nextFrame);
                tracks(i).DLT = step_dlt;
                tracks(i).bbox = bbox;
                
                % Update visibility.
                tracks(i).totalVisibleCount = tracks(i).totalVisibleCount + 1;
                tracks(i).age = tracks(i).age + 1;
                
                % Update centroids
                centroid = [bbox(1) + (bbox(3)/2), bbox(2) + (bbox(4)/2)];
                tracks(i).prevCentroid = tracks(i).curCentroid;
                tracks(i).curCentroid = centroid;

                msg = sprintf('\ttrack(%d) : [%.3f, %.3f, %.3f, %.3f]  -->  [%.3f, %.3f, %.3f, %.3f] with centrod [%.3f, %.3f]\n', i, ...
                                        oldBbox(1), oldBbox(2), oldBbox(3), oldBbox(4), ...
                                        bbox(1), bbox(2), bbox(3), bbox(4), ...
                                        centroid(1,1), centroid(1,2));
                disp(msg);
                
                
                % Number of tracks updated
                updatedTracks = updatedTracks + 1;
                
            else
               msg = sprintf('\tInactive Track(%d) : [%.3f, %.3f, %.3f, %.3f]\n', i, ...
                                        oldBbox(1), oldBbox(2), oldBbox(3), oldBbox(4)); 
               disp(msg);
            end
        end
    end


%% Find which BBoxes are not still being tracked
    function [newTracks] = detectUntrackedBBoxes()
        
        newTracks = 0;
        if isempty(tracks)  % If no tracks already created, all BBOx's are assigned a track
%                     bboxes = [200, 0, 30, 30];   % Uncomment for test puposes on
%                     HighWay sequence
            for i=1:size(bboxes, 1)
                msg = sprintf('\tCreate Track with Id = %d', nextId);
                disp(msg);
                bbox = bboxes(i,:);
                dlt = Init_DLT(frame, [bbox, 0]);
                [bbox, step_dlt] = Step_DLT(dlt, frame, nextFrame);
                
                centroid = [bbox(1) + (bbox(3)/2), bbox(2) + (bbox(4)/2)];
                
                % Create a new track.
                newTrack = struct(...
                    'id', nextId, ...
                    'bbox', bbox, ...
                    'DLT', step_dlt,...
                    'active', 1, ...
                    'age', 1, ...
                    'totalVisibleCount', 1, ...
                    'initialCentroid', centroid, ...
                    'prevCentroid', centroid, ...
                    'curCentroid', centroid, ...
                    'speed', 0, ...
                    'consecutiveInvisibleCount', 0);

                % Add it to the array of tracks.
                tracks(end + 1) = newTrack;

                % Increment the next id.
                nextId = nextId + 1;
                newTracks = newTracks + 1;
            end
            
            return;
        end

        trackedBboxes = reshape([tracks(:).bbox], 4, [])';
        overlapThres = 0.3;
        
        nAssTracks = size(trackedBboxes, 1);
        nUnassTracks = size(bboxes, 1);
        ratio = [];
        if (nAssTracks>0 && nUnassTracks>0)
            ratio = bboxOverlapRatio(bboxes, trackedBboxes);
        end
        
        
        % 
        
        % Find the BBoxes that are not being tracked yet
        for i=1:size(ratio, 1)
            [argvalue, argmax] = max(ratio(i,:));
            if(argvalue<overlapThres) % Create new Track
                bbox = bboxes(i,:);
                dlt = Init_DLT(frame, [bbox, 0]);
                
                [bbox, step_dlt] = Step_DLT(dlt, frame, nextFrame);
                centroid = [bbox(1) + (bbox(3)/2), bbox(2) + (bbox(4)/2)];
                newTracks = newTracks + 1;
                % Create a new track.
                newTrack = struct(...
                    'id', nextId, ...
                    'bbox', bbox, ...
                    'DLT', step_dlt,...
                    'active', 1, ...
                    'age', 1, ...
                    'totalVisibleCount', 1, ...
                    'initialCentroid', centroid, ...
                    'prevCentroid', centroid, ...
                    'curCentroid', centroid, ...
                     'speed', 0, ...
                    'consecutiveInvisibleCount', 0);
                
                
                msg = sprintf('\tCreate Track with Id = %d', nextId);
                disp(msg);
                
                % Add it to the array of tracks.
                tracks(end + 1) = newTrack;

                % Increment the next id.
                nextId = nextId + 1;
            end
        end
    
    end

    function updateInstantSpeed()
    %Computes instant speed of each object comparing centrois in previous and
    %current frame

        for i = 1:size(tracks, 1)

            if tracks(i).active == 0  % Only compute instant speed of active trackers                
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

%% Create System Objects
    function obj = setupDLTSystemObjects()
                
        % Indicate whether to use GPU in computation.
        global useGpu;
        useGpu = false;
        
        % Paths to the functions containing the DNN implementations
        addpath('DLTcode\DLT\');
        addpath('DLT\affineUtility\');
        addpath('DLT\drawUtility\');
        addpath('imageUtility\');
        addpath('DLT\NN\');
        
        
        % Initialize Video I/O
        % Create objects for reading a video from a file, drawing the tracked
        % objects in each frame, and playing the video.
        
        % Create a video file reader.
        obj.reader = vision.VideoFileReader('highway_1700frames_10fps.avi');
        
        % Create two video players, one to display the video,
        % and one to display the foreground mask.
        obj.videoPlayer = vision.VideoPlayer('Position', [20, 400, 700, 400]);
        obj.maskPlayer = vision.VideoPlayer('Position', [740, 400, 700, 400]);
        
        % Create System objects for foreground detection and blob analysis
        
        % The foreground detector is used to segment moving objects from
        % the background. It outputs a binary mask, where the pixel value
        % of 1 corresponds to the foreground and the value of 0 corresponds
        % to the background. 
        
        obj.detector = vision.ForegroundDetector('NumGaussians', 3, ...
            'NumTrainingFrames', 40, 'MinimumBackgroundRatio', 0.4);
        
        % Connected groups of foreground pixels are likely to correspond to moving
        % objects.  The blob analysis System object is used to find such groups
        % (called 'blobs' or 'connected components'), and compute their
        % characteristics, such as area, centroid, and the bounding box.
        
%         obj.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
%             'AreaOutputPort', true, 'CentroidOutputPort', true, ...
%             'MinimumBlobArea', 900);

        obj.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, ...
            'AreaOutputPort', true, 'CentroidOutputPort', true, ...
            'MinimumBlobArea', 400);

    end

%% Initialize Tracks
    function tracks = initializeDLTracks()
        % create an empty array of tracks
        tracks = struct(...
            'id', {}, ...
            'bbox', {}, ...
            'DLT', {}, ...
            'active', {}, ...
            'age', {}, ...
            'totalVisibleCount', {}, ...
            'initialCentroid', {}, ...
            'prevCentroid', {}, ...
            'curCentroid', {}, ...
            'speed', {}, ...
            'consecutiveInvisibleCount', {});        
    end

%% Read a Video Frame
    function frame = readFrame()
        frame = obj.reader.step();
    end

% Detect Objects
    function [centroids, bboxes, mask] = objectDetector(frame)
        
        % Detect foreground.
        mask = obj.detector.step(frame);
        
        % Apply morphological operations to remove noise and fill in holes.
%         mask = imopen(mask, strel('rectangle', [3,3]));
%         mask = imclose(mask, strel('rectangle', [5, 7])); 
%         mask = imfill(mask, 'holes');

    mask = imopen(mask, strel('rectangle', [5,5]));
    mask = imclose(mask, strel('rectangle', [10, 10])); 
    mask = imfill(mask, 'holes');
        
        % Perform blob analysis to find connected components.
        [~, centroids, bboxes] = obj.blobAnalyser.step(mask);
        
        msg = '';
        for i=1:size(bboxes, 1)
            msg =sprintf('%s\tBbox(%d) = [%.3f, %.3f, %.3f, %.3f]\n', msg, i, bboxes(i,1), bboxes(i,2), bboxes(i,3), bboxes(i,4));
        end
        disp(msg);
    end





%% Display Tracking Results
% The |displayTrackingResults| function draws a bounding box and label ID 
% for each track on the video frame and the foreground mask. It then 
% displays the frame and the mask in their respective video players. 

    function displayDLTrackingResults()
        % Convert the frame and the mask to uint8 RGB.
        frame = im2uint8(frame);
        mask = uint8(repmat(mask, [1, 1, 3])) .* 255;
        
        minVisibleCount = 0;
%         minVisibleCount = 8;
        if ~isempty(tracks)
              
            % Noisy detections tend to result in short-lived tracks.
            % Only display tracks that have been visible for more than 
            % a minimum number of frames.
%             reliableTrackInds = ...
%                 [tracks(:).totalVisibleCount] > minVisibleCount;

            reliableTrackInds = ...
                [tracks(:).active] == 1;
            reliableTracks = tracks(reliableTrackInds);
            
            % Display the objects. If an object has not been detected
            % in this frame, display its predicted bounding box.
            if ~isempty(reliableTracks)
                % Get bounding boxes.
                bboxes = cat(1, reliableTracks.bbox);
                
                % Get ids.
                ids = int32([reliableTracks(:).id]);
                
                % Create labels for objects indicating the ones for 
                % which we display the predicted rather than the actual 
                % location.
%                 labels = cellstr(int2str(ids'));
%                 predictedTrackInds = ...
%                     [reliableTracks(:).consecutiveInvisibleCount] > 0;
%                 isPredicted = cell(size(labels));
%                 isPredicted(predictedTrackInds) = {' predicted'};
%                 labels = strcat(labels, isPredicted);
                
                labels = {};
                for i=1:size(reliableTracks, 1)
                   labels{i} = strcat([num2str(round(reliableTracks(i).id)), ' - ', ...
                                        num2str(round(reliableTracks(i).speed)) , 'km/h']);
                end
                
                % Draw the objects on the frame.
                frame = insertObjectAnnotation(frame, 'rectangle', ...
                    bboxes, labels);
                
                % Draw the objects on the mask.
                mask = insertObjectAnnotation(mask, 'rectangle', ...
                    bboxes, labels);
            end
        end
        
        % Display the mask and the frame.
        obj.maskPlayer.step(mask);        
        obj.videoPlayer.step(frame);
    end


%% Initialize Deep Learning Tracker
    function [dlt] = Init_DLT(frame, bbox)       
        

   
        % p = [px, py, sx, sy, theta]; The location of the target in the first
        % frame.
        % px and py are th coordinates of the centre of the box
        % sx and sy are the size of the box in the x (width) and y (height)
        %   dimensions, before rotation
        % theta is the rotation angle of the box
%         pppppppp = bbox; %[200 0 30 30 0];
        bbox = double(bbox);
        
        dlt.opt = struct('numsample',1000, 'affsig',[4,4,.02,.0,.001,.00]);


        % The number of previous frames used as positive samples.
        dlt.opt.maxbasis = 10;
        dlt.opt.updateThres = 0.8;
        dlt.opt.condenssig = 0.01;
        dlt.opt.tmplsize = [32, 32];
        dlt.opt.normalWidth = 320;
        dlt.opt.normalHeight = 240;
       
        pos_x = bbox(1);% + bbox(3);
        pos_y = bbox(2);% + bbox(4);
        size_x = bbox(3);
        size_y = bbox(4);
        dlt.init_rect = [pos_x, pos_y, size_x, size_y, bbox(5)]; 
        msg = sprintf('\tFLT_Init : InitialBBOX (%d, %d, %d, %d)\n', bbox(1), bbox(2), bbox(3), bbox(4));
%         disp(msg);
       
        msg = sprintf('\tFLT_Init : InitialRECT (%d, %d, %d, %d)\n', pos_x, pos_y, size_x, size_y);
%         disp(msg);


        rand('state',0);  randn('state',0);
        if isfield(dlt, 'opt')
%             opt = seq.opt;
            opt = dlt.opt;
        else
            trackparam_DLT;
        end
        rect=dlt.init_rect;
        pppppp = [rect(1)+rect(3)/2, rect(2)+rect(4)/2, rect(3), rect(4), 0];

        if size(frame,3)==3
            frame = double(rgb2gray(frame));
        end

%         max(max(frame))
        
        scaleHeight = size(frame, 1) / opt.normalHeight;
        scaleWidth = size(frame, 2) / opt.normalWidth;
        pppppp(1) = pppppp(1) / scaleWidth;
        pppppp(3) = pppppp(3) / scaleWidth;
        pppppp(2) = pppppp(2) / scaleHeight;
        pppppp(4) = pppppp(4) / scaleHeight;
        frame = imresize(frame, [opt.normalHeight, opt.normalWidth]);
        frame = double(frame) ;%/ 255;


        paramOld = [pppppp(1), pppppp(2), pppppp(3)/opt.tmplsize(2), pppppp(5), pppppp(4) /pppppp(3) / (opt.tmplsize(1) / opt.tmplsize(2)), 0];
        param0 = affparam2mat(paramOld);


        if ~exist('opt','var')  opt = [];  end
        if ~isfield(opt,'minopt')
          opt.minopt = optimset; opt.minopt.MaxIter = 25; opt.minopt.Display='off';
        end
        reportRes = [];
        

        tmpl.mean = warpimg(frame, param0, opt.tmplsize);           % DESDE AQUIIIIIIIIIIIIIIIIII

        tmpl.basis = [];
        % Sample 10 positive templates for initialization
        for i = 1 : opt.maxbasis / 10
            tmpl.basis(:, (i - 1) * 10 + 1 : i * 10) = samplePos_DLT(frame, param0, opt.tmplsize);
        end
        % Sample 100 negative templates for initialization
        p0 = paramOld(5);
        tmpl.basis(:, opt.maxbasis + 1 : 100 + opt.maxbasis) = sampleNeg(frame, param0, opt.tmplsize, 100, opt, 8);

        param.est = param0;
        param.lastUpdate = 1;

        drawopt.showcondens = 0;  drawopt.thcondens = 1/opt.numsample;
        
        % track the sequence from frame 2 onward
        if (exist('dispstr','var'))  dispstr='';  end
        L = [ones(opt.maxbasis, 1); (-1) * ones(100, 1)];
        nn = initDLT(tmpl, L);
        L = [];
        pos = tmpl.basis(:, 1 : opt.maxbasis);
        pos(:, opt.maxbasis + 1) = tmpl.basis(:, 1);
        opts.numepochs = 5;
        
        dlt.opt = opt;
        dlt.opts = opts;
        dlt.pos = pos;
        dlt.tmpl = tmpl; 
        dlt.nn = nn;
        dlt.L = L;
        dlt.param = param;
        dlt.scaleWidth = scaleWidth;
        dlt.scaleHeight = scaleHeight;
        dlt.reportRes = reportRes; 
        dlt.drawopt = drawopt;
        
        dlt.p0 = p0;

    end


    function [bbox, step_dlt] = Step_DLT(dlt, frame, fffffff)

        opt = dlt.opt;
        opts = dlt.opts;
        pos = dlt.pos;
        tmpl = dlt.tmpl; 
        nn = dlt.nn;
        L = dlt.L;
        param = dlt.param;
        scaleWidth = dlt.scaleWidth;
        scaleHeight = dlt.scaleHeight;
        reportRes = dlt.reportRes; 
        drawopt = dlt.drawopt;   
        
        
        % FOR EACH FRAMEIN THE SEQUENCE
          if size(frame,3)==3
            frame = double(rgb2gray(frame));
          end  
          frame = imresize(frame, [opt.normalHeight, opt.normalWidth]);
          frame = double(frame); % / 255;

          % do tracking
          param = estwarp_condens_DLT(frame, tmpl, param, opt, nn, fffffff);  % HASTA AQUIIIIIIIIIIIII
        

          % do update
          temp = warpimg(frame, param.est', opt.tmplsize);
          pos(:, mod(fffffff - 1, opt.maxbasis) + 1) = temp(:);
          if  param.update
              disp('PARAAAAAM UPDATEEEEs');
              opts.batchsize = 10;
              % Sample two set of negative samples at different range.
              neg = sampleNeg(frame, param.est', opt.tmplsize, 49, opt, 8);
              neg = [neg sampleNeg(frame, param.est', opt.tmplsize, 50, opt, 4)];
              nn = nntrain(nn, [pos neg]', [ones(opt.maxbasis + 1, 1); zeros(99, 1)], opts);
          end


          res = affparam2geom(param.est);
          p(1) = round(res(1));
          p(2) = round(res(2)); 
          p(3) = round(res(3) * opt.tmplsize(2));
          p(4) = round(res(5) * (opt.tmplsize(1) / opt.tmplsize(2)) * p(3));
          p(5) = res(4);
          
          p(1) = p(1) * scaleWidth;
          p(3) = p(3) * scaleWidth;
          p(2) = p(2) * scaleHeight;
          p(4) = p(4) * scaleHeight;
          paramOld = [p(1), p(2), p(3)/opt.tmplsize(2), p(5), p(4) /p(3) / (opt.tmplsize(1) / opt.tmplsize(2)), 0];
          
          
          reportRes = [reportRes;  affparam2mat(paramOld)];

          tmpl.basis = [pos];

%         pppppp = [rect(1)+rect(3)/2, rect(2)+rect(4)/2, rect(3), rect(4), 0];
        bbox = [p(1) - p(3)/2, p(2) - p(4)/2, p(3), p(4)];
        
        
        
        step_dlt = dlt;
        step_dlt.param = param;
        
        step_dlt.opt = opt;
        step_dlt.opts = opts;
        step_dlt.pos = pos;
        step_dlt.tmpl = tmpl; 
        step_dlt.nn = nn;
        step_dlt.L = L;
        step_dlt.scaleWidth = scaleWidth;
        step_dlt.scaleHeight = scaleHeight;
        step_dlt.reportRes = reportRes; 
        step_dlt.drawopt = drawopt;
    end



%% Summary
% This example created a motion-based system for detecting and
% tracking multiple moving objects. Try using a different video to see if
% you are able to detect and track objects. Try modifying the parameters
% for the detection, assignment, and deletion steps.  
%
% The tracking in this example was solely based on motion with the
% assumption that all objects move in a straight line with constant speed.
% When the motion of an object significantly deviates from this model, the
% example may produce tracking errors. Notice the mistake in tracking the
% person labeled #12, when he is occluded by the tree. 
%
% The likelihood of tracking errors can be reduced by using a more complex
% motion model, such as constant acceleration, or by using multiple Kalman
% filters for every object. Also, you can incorporate other cues for
% associating detections over time, such as size, shape, and color. 

displayEndOfDemoMessage(mfilename)
end




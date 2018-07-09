function ObjectDetection()
obj = MainSystem(); % Main System object contain video I/O & Masking

tracks = initializeTracks(); % Empty Array 'tracks' for processed frames

nextId = 1; % ID of tracks
global frame;
global mask;
global grayframe;

% I/O intialization done it calls sub functions
    while ~isDone(obj.reader)
    frame = readFrame();
    %frame = grayframe ;
    
    %rgbhistogram();
    [centroids, bboxes, mask] = ObjectsDetect(frame);
    nextLocationsTracks();
    [assignments, unassignedTracks, unassignedDetections] = detectionToTrackAssignment();
    
    updateAssignedTracks();
    updateUnassignedTracks();
    deleteLostTracks();
    createNewTracks();
    displayTrackingResults();
    %rgbhistogram();
    end


%% Main System
  
    % Objects used for reading the video frames, detecting
    % foreground by segmentation , and displaying results.
    function obj = MainSystem()
        global test;
        %global filename2;
        
        %filename2=filename;
        
        % Initialize Video I/O 
       
        obj.reader = vision.VideoFileReader('test.mp4');
        
        % Three video players,
        %global videoPlayer;
        %obj.videoPlayer=videoPlayer;
        obj.videoPlayer = vision.VideoPlayer('Name','RGB Video','Position',[20, 250, 450, 400]);
        obj.maskPlayer = vision.VideoPlayer('Name','Binary MASK','Position',[840, 250, 450, 400]);
        obj.grayPlayer = vision.VideoPlayer('Name','Gray Scale Video');
        %.histPlayer = vision.VideoPlayer('Name','RGB HIST Video');
        %obj.hHist = vision.Histogram('LowerLimit', 0,'UpperLimit', 1,'NumBins', 256);
        
        
        % Create objects for foreground detection and blob analysis
               global thresholdvalue ;
        obj.detector = vision.ForegroundDetector('NumGaussians', 3,'NumTrainingFrames', 40, 'MinimumBackgroundRatio', 1);
        
        
        % ERROR here, need to solve 
        % detector = vision.ForegroundDetector('NumTrainingFrames', 5, 'InitialVariance', 30*30); 
        % blob = vision.BlobAnalysis('CentroidOutputPort', false, 'AreaOutputPort', false,'BoundingBoxOutputPort', true,'MinimumBlobAreaSource', 'Property', 'MinimumBlobArea', 250);
        
       
        
             
        
        
        % Connected groups of foreground pixels 
        
        obj.blobAnalyser = vision.BlobAnalysis('BoundingBoxOutputPort', true, 'AreaOutputPort', true, 'CentroidOutputPort', true,'MinimumBlobArea', 400);
        
        
        
    end

%% Initializing Tracks

       function tracks = initializeTracks()
        % Tracks is empty structure
        % |id| :                  the integer ID of the track
        % |bbox| :                the current bounding box of the object; used for display
        % |kalmanFilter| :        a Kalman filter object used for tracking
        %  |age| :                 the number of frames since the track was first detected                      
        % |totalVisibleCount| :   the total number of frames 
        % |consecutiveInvisibleCount| : the number of consecutive frames for which the track was not detected (invisible)
        %                                
        
        tracks = struct('id', {},'bbox', {},'kalmanFilter', {},'age', {},'totalVisibleCount', {},'consecutiveInvisibleCount', {});
    end

%% Read a Video Frame
    % Read the next video frame from the video file.
    function frame = readFrame()
        %global frame ;
        frame = obj.reader.step();
        
    end


%% Object Detection
    % The function returns the centroids and the bounding boxes of the detected objects,
    % It also returns the binary mask, which has the same size as the input frame,
    

    function [centroids, bboxes, mask] = ObjectsDetect(frame)
        
        % Foreground.
        mask = obj.detector.step(frame); % Function performs motion segmentation using the foreground
        
        % Apply morphological operations to remove noise
        mask = imopen(mask, strel('rectangle', [3,3])); % For Openning opertation
        mask = imclose(mask, strel('rectangle', [15, 15])); % For Closing operation
        
        % Fill image regions and holes, removes short noise 
        mask = imfill(mask, 'holes'); 
                
        
        % Median filter
        % mask = imnoise(mask,'salt & pepper' , 0.02)
        mask = medfilt2(mask);
        
        
        % Perform blob analysis to find connected components.
        [~, centroids, bboxes] = obj.blobAnalyser.step(mask);
    end

%% Next predicted location of track
    % Use the Kalman filter to predict the centroid of each track in the
    % current frame, and update its bounding box accordingly.

    function nextLocationsTracks()
        for i = 1:length(tracks)
            bbox = tracks(i).bbox;
            
            % Predict the current location of the track
            predictedCentroid = predict(tracks(i).kalmanFilter);
            
            % Shift the bounding box so that its center is at the predicted location
            predictedCentroid = int32(predictedCentroid) - bbox(3:4) / 2;
            tracks(i).bbox = [predictedCentroid, bbox(3:4)];
        end
    end


%% Assign Detections to Tracks
    % Assigning object detections in the current frame to existing tracks
    
    % Algorithm 
    function [assignments, unassignedTracks, unassignedDetections] = detectionToTrackAssignment()
        
        nTracks = length(tracks);
        nDetections = size(centroids, 1);
        
        % Compute the cost of assigning each detection to each track.
        cost = zeros(nTracks, nDetections);
        for i = 1:nTracks
            cost(i, :) = distance(tracks(i).kalmanFilter, centroids);
        end
        
        % Solve the assignment problem.
        costOfNonAssignment = 20;
        [assignments, unassignedTracks, unassignedDetections] = assignDetectionsToTracks(cost, costOfNonAssignment);
    end

%% Update Assigned Tracks
    % The function updates each assigned track with the corresponding detection.

    function updateAssignedTracks()
        numAssignedTracks = size(assignments, 1);
            for i = 1:numAssignedTracks
            trackIdx = assignments(i, 1);
            detectionIdx = assignments(i, 2);
            centroid = centroids(detectionIdx, :);
            bbox = bboxes(detectionIdx, :);
            
            % Correct the estimate of the object's location
            % using the new detection.
            correct(tracks(trackIdx).kalmanFilter, centroid);
            
            % Replace predicted bounding box with detected bounding box.
            tracks(trackIdx).bbox = bbox;
            
            % Update track's age.
            tracks(trackIdx).age = tracks(trackIdx).age + 1;
            
            % Update visibility.
            tracks(trackIdx).totalVisibleCount = ...
                tracks(trackIdx).totalVisibleCount + 1;
            tracks(trackIdx).consecutiveInvisibleCount = 0;
            end
    end

%% Update Unassigned Tracks
    % Mark each unassigned track as invisible, and increase its age by 1.

    function updateUnassignedTracks()
        for i = 1:length(unassignedTracks)
            ind = unassignedTracks(i);
            tracks(ind).age = tracks(ind).age + 1;
            tracks(ind).consecutiveInvisibleCount = ...
                tracks(ind).consecutiveInvisibleCount + 1;
        end
    end

%% For Corrupt Video and Delete Lost Tracks 
    % For Corrupted video
    % The function deletes tracks that have been invisible for too many consecutive frames.
  
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

%% Create New Tracks
   
    function createNewTracks()
        centroids = centroids(unassignedDetections, :);
        bboxes = bboxes(unassignedDetections, :);
        
        for i = 1:size(centroids, 1)
            
            centroid = centroids(i,:);
            bbox = bboxes(i, :);
            
            % Create a Kalman filter object.
            kalmanFilter = configureKalmanFilter('ConstantVelocity',centroid, [200, 50], [100, 25], 100);
            
            % Create a new track.
            newTrack = struct('id', nextId, 'bbox', bbox, 'kalmanFilter', kalmanFilter, 'age', 1, 'totalVisibleCount', 1, 'consecutiveInvisibleCount', 0);
            
            % Add it to the array of tracks.
            tracks(end + 1) = newTrack;
            
            % Increment the next id.
            nextId = nextId + 1;
        end
    end

%% Display Tracking Results
    % The function draws a bounding box and label ID for each track on the video frame and the foreground mask 
    % It then displays the frame and the mask in their respective video players

    function displayTrackingResults()
        
        global labels ;
        % Convert the frame and the mask to uint8 RGB.
        frame = im2uint8(frame);
        
        mask = uint8(repmat(mask, [1, 1, 3])) .* 255;
        
        grayframe = im2uint8(frame);
        
        minVisibleCount = 8;
        if ~isempty(tracks)
              
       
            % Only display tracks that have been visible for more than a minimum number of frames.
            reliableTrackInds = [tracks(:).totalVisibleCount] > minVisibleCount;
            reliableTracks = tracks(reliableTrackInds);
            
            % Display the objects. If an object has not been detected in this frame, display its predicted bounding box.
            if ~isempty(reliableTracks)
                
                % Get bounding boxes.
                bboxes = cat(1, reliableTracks.bbox);
                
                % Get ids.
                ids = int32([reliableTracks(:).id]);
                
                % Label functions for Count no.
                labels = cellstr(int2str(ids'));
                predictedTrackInds = ...
                    [reliableTracks(:).consecutiveInvisibleCount] > 0;
                isPredicted = cell(size(labels));
                isPredicted(predictedTrackInds) = {''};
                labels = strcat(labels,isPredicted);
                
                % Draw the objects on the frame.
                frame = insertObjectAnnotation(frame, 'rectangle', bboxes, labels, 'Color' ,  {'red'});
               
                % Draw the objects on the grayframe.
                grayframe = insertObjectAnnotation((rgb2gray(frame)),'rectangle', bboxes, labels, 'Color' ,  {'blue'});
                
                % Draw the objects on the mask.
                mask = insertObjectAnnotation(mask, 'rectangle', bboxes, labels, 'Color' ,  {'magenta'});
                
                
                
            end
        end
      
      
        % Display the mask and the frame.
        obj.maskPlayer.step(mask);        % for Mask
        obj.videoPlayer.step(frame);      % for Frames
        obj.grayPlayer.step(grayframe);   % for GrayScale
        %obj.histPlayer.step(videohistplots(3,cat(3, R_hist,G_hist,B_hist)));
        %rgbhistogram();
        %set(handles.text8,'String',labels);
    end
%global labels;
%display(labels);
    %set(handles.edit2,'String',labels);
   %set(handles.text8,'String',labels);

end

clear all;

% get images
buildingDir = fullfile(toolboxdir('vision'), 'visiondata', 'building');
buildingScene = imageDatastore(buildingDir);
I1 = rgb2gray(readimage(buildingScene, 1));
I2 = rgb2gray(readimage(buildingScene, 2));

% get points
points1 = detectHarrisFeatures(I1);
points2 = detectHarrisFeatures(I2);

% get features
[features1, points1] = extractFeatures(I1, points1);
[features2, points2] = extractFeatures(I2, points2);

loc1 = points1.Location;
loc2 = points2.Location;

[match,match_fwd,match_bkwd] = match_features(double(features1.Features),double(features2.Features));

figure()
plot_corr(I1,I2,loc1(match_fwd(:,1),:),loc2(match_fwd(:,2),:));

figure()
plot_corr(I1,I2,loc1(match_bkwd(:,1),:),loc2(match_bkwd(:,2),:));

figure()
plot_corr(I1,I2,loc1(match(:,1),:),loc2(match(:,2),:));

function [match,match_fwd,match_bkwd] = match_features(f1,f2)
    %% INPUT
    %% f1,f2: [ number of points x number of features ]
    %% OUTPUT
    %% match, match_fwd, match_bkwd: [ indices in f1, corresponding indices in f2 ]
    
    % get matches using pdist2 and the ratio test with threshold of 0.7
    % fwd matching
    d_1=pdist2(f1,f2);
    dd1=sort(d_1,'descend');
    for i=1:size(dd1)
        if (dd1(i)/dd1(i+1))>0.7
            dd1(i)=0;
        end
    end
    
    
    
    match_fwd = dd1;
    % bkwd matching
    
    
    match_bkwd = 
    % fwd bkwd consistency check
    match = 
end

function [ visiblePoints ] = KLT_tracking(points, old_img, new_img)
%points: input points from previous image
%new points: corresponding new points in the new image
pointTracker = vision.PointTracker('MaxBidirectionalError', 2);

% Initialize the tracker with the initial point locations and the initial
% video frame.
initialize(pointTracker, points, old_img);
oldPoints = points;

% Track the points. Note that some points may be lost.
[points, isFound] = step(pointTracker, new_img);
visiblePoints = points(isFound, :);
oldInliers = oldPoints(isFound, :);

if size(visiblePoints, 1) >= 2 % need at least 2 points

    % Estimate the geometric transformation between the old points
    % and the new points and eliminate outliers
    [xform, oldInliers, visiblePoints] = estimateGeometricTransform(...
        oldInliers, visiblePoints, 'similarity', 'MaxDistance', 4);

    % Reset the points
    oldPoints = visiblePoints;
    setPoints(pointTracker, oldPoints);        
end

% Display the annotated video frame using the video player object
release(pointTracker);
end


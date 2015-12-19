function convexhull_pts = convex_mask( pts )
%UNTITLED5 Summary of this function goes here
%   Input: -pts: n by 2 points vector
%   Output: -convexhull_pts: n by 2 mask boundary points

K = convhull(pts(:,1),pts(:,2));

convexhull_pts = pts(K,:);

end


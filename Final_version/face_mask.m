function convex_pts = face_mask(landmark_points)

if size(landmark_points,1)==83
    flag = 83;
    start_pos = 20;
elseif size(landmark_points,1)==25
    flag = 25;
    start_pos = 1;
else
    start_pos = 1;
end


X = landmark_points(start_pos:end,1);
Y = landmark_points(start_pos:end,2);

%    X = zeros(flag-start_pos, 1);
%    Y = zeros(flag-start_pos, 1);
%    j = start_pos;
%    for i = 1:length(X)
%        pt = getfield(landmark_points, landmark_names{j});
%        X(i) = pt.x; Y(i) = pt.y;
%        j = j+1;
%    end
pts = struct('x', X, 'y', Y);
DT = delaunayTriangulation(pts.x,pts.y);
K = convexHull(DT);
convex_pts = DT.Points(K, :);
end
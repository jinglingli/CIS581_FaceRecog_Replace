function K = face_mask(landmark_points, landmark_names)

if size(landmark_names,1)==83
    flag = 83;
    start_pos = 20;
elseif size(landmark_names,1)==25
    flag = 25;
    start_pos = 1;
end
X = zeros(flag-start_pos, 1);
Y = zeros(flag-start_pos, 1);
% Draw facial key points
j = start_pos;
for i = 1:length(X)
    pt = getfield(landmark_points, landmark_names{j});
    X(i) = pt.x; Y(i) = pt.y;
    j = j+1;
end
pts = struct('x', X, 'y', Y);
DT = delaunayTriangulation(pts.x,pts.y);
K = convexHull(DT);

end
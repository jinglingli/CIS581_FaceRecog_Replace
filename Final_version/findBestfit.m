function [im2, im2_pts] = findBestfit(im1_pts)
rep_img_dir = dir('../replacement_face/*.jpg');
rep_feature_dir = dir('../replacement_face/*.mat');
min_angle = 180;
for i = 1:length(ims),
    im = imread(['../replacement_face/' rep_img_dir(i).name]);
    im2_pts = load(['../replacement_face/' rep_feature_dir(i).name]);
    common = (im2_pts(:,1)>0) & (im1_pts(:,1)>0);
    if size(common,1) == 83
        common(1:20) = false;
    end 
    tar_pts = im1_pts(common,:);
    rep_pts = im2_pts(common,:);
    tform = fitgeotrans(tar_pts,rep_pts,'projective');
    H = est_homography(tar_pts(1,:),tar_pts(2,:),rep_pts(1,:),rep_pts(2,:));
    tform.T = H;
    u = [0 1];
    v = [0 0];
    [x, y] = transformPointsForward(tform, u, v);
    dx = x(2) - x(1);
    dy = y(2) - y(1);
    angle = abs((180/pi) * atan2(dy, dx));
    if angle < min_angle
        min_angle = angle;
        im2 = im;
        im2_pts = pts;
    end
end
end
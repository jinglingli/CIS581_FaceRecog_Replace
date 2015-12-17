%% Obtain facial features
target = 'frame2.png';
replacement  = 'replacement.jpg';

im1 = imread(target); im2 = imread(replacement);
if ~isequal(size(im1),size(im2))
    disp('It would be better to keep the size of the two input images be the same.');
    display('Resizing the image now...')
    [im1r, im1c, ~] = size(im1);
    [im2r, im2c, ~] = size(im2);
    im2 = imresize(im2,[im1r, im1c]);   
    %replacement = 'replacement2.jpg';
    %imwrite(im2, replacement);
end
target_pts = correspondences(target);
replacement_pts = correspondences(replacement);
im1_pts = [target_pts{1,1}.x target_pts{1,1}.y];
im2_pts = [replacement_pts{1,1}.x replacement_pts{1,1}.y];

im2_pts(:,1) = im2_pts(:,1)*size(im1,2)/im2c;
im2_pts(:,2) = im2_pts(:,2)*size(im1,1)/im2r;
%% Morph image
warp_frac = 0;
dissolve_frac = 0.8;
    
morphed_im = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac);
%{
figure;
imshow(morphed_im);
hold on;

% Draw facial key points
for i = 1 : 83
    scatter(im1_pts(i,1), im1_pts(i,2), 'g.'); 
    %scatter(im1_pts(i,1) * img_width / 100, im1_pts(i,2) * img_height / 100, 'g.');
end

hold off
%}
%% Find face mask
convex_pts = face_mask(im1_pts);
%{
figure;
imshow(morphed_im);
hold on;
scatter(convex_pts(:,1), convex_pts(:,2), 'g.');
hold off;
%}
binary_mask = poly2mask(convex_pts(:,1), convex_pts(:,2), im1r, im1c);

%% Apply face mask and blend images
img_blend = poisson_blending(morphed_im, im1, binary_mask );
imshow(uint8(img_blend))
%% If no face detected, use tracking
old_img_name = 'frame91.png';
new_img_name = 'frame103.png';

old_img = imread(old_img_name); new_img = imread(new_img_name);
old_img_pts = correspondences(old_img_name);
points = [old_img_pts{1,1}.x old_img_pts{1,1}.y];

[ new_points ] = KLT_tracking(points, old_img, new_img);
figure;
imshow(new_img);
hold on;
scatter(new_points(:,1), new_points(:,2), 'g.');
hold off;
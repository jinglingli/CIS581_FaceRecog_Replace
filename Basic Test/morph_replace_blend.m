function img_blend = morph_replace_blend(im1, im2, im1_pts, im2_pts)
%% Morph image
warp_frac = 0;
dissolve_frac = 1;
    
morphed_im = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac);
%{
figure;
imshow(im2);
hold on;

% Draw facial key points
for i = 1 : 83
    scatter(im2_pts(i,1), im2_pts(i,2), 'g.'); 
    %scatter(im1_pts(i,1) * img_width / 100, im1_pts(i,2) * img_height / 100, 'g.');
end

hold off
%}
%% Find face mask
%convex_pts = convex_mask(im1_pts);
convex_pts = face_mask(im1_pts);
%{
figure;
imshow(morphed_im);
hold on;
scatter(convex_pts(:,1), convex_pts(:,2), 'g.');
hold off;
%}
binary_mask = poly2mask(convex_pts(:,1), convex_pts(:,2), size(im1,1), size(im1,2));

%% Apply face mask and blend images
img_blend = poisson_blending(morphed_im, im1, binary_mask );

end
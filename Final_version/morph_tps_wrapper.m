function [morphed_im, ctr_pts_morph] = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac)
ctr_pts = im2_pts*warp_frac + (1-warp_frac)*im1_pts; %ctr_pts = im1_pts;
[nr, nc, ~] = size(im1); sz = [nr, nc];
rep_pts = im2_pts;

%I1 = padarray(im1,[pad_x pad_y],'symmetric');I1 = double(I1);
%I2 = padarray(im2,[pad_x pad_y],'symmetric');I2 = double(I2);

target_value = im1_pts; im_source = im1;
[a1_x,ax_x,ay_x,w_x] = est_tps(ctr_pts, target_value(:,1)); %X values 
[a1_y,ax_y,ay_y,w_y] = est_tps(ctr_pts, target_value(:,2)); %Y values
[morphed_im1, pts_morph1] = morph_tps(im_source, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, ctr_pts, sz, rep_pts);

target_value = im2_pts; im_source = im2;
[a1_x,ax_x,ay_x,w_x] = est_tps(ctr_pts, target_value(:,1)); %X values 
[a1_y,ax_y,ay_y,w_y] = est_tps(ctr_pts, target_value(:,2)); %Y values
[morphed_im2, pts_morph2] = morph_tps(im_source, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, ctr_pts, sz, rep_pts);
%figure; imagesc(morphed_im2)

morphed_im = morphed_im2*dissolve_frac + morphed_im1*(1-dissolve_frac); %morphed_im = morphed_im2
ctr_pts_morph = pts_morph2*warp_frac + (1-warp_frac)*pts_morph1;
%figure; imagesc(morphed_im);
end


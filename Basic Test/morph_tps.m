function [morphed_im, ctr_pts_morph] = morph_tps(im_source, a1_x, ax_x, ay_x, w_x, a1_y, ax_y, ay_y, w_y, ctr_pts, sz, rep_pts)
% a1_x, ax_x, ay_x, w_x are the parameters solved when doing est_tps in the x direction.
% a1_y, ax_y, ay_y, w_y are the parameters solved when doing est_tps in the y direction.
% ctr_pts are the control points used (the second and third columns of P)
% sz is the desired size for morphed im stored as [rows, cols] when the image sources are of difference sizes
%pad_x = 2; pad_y = 2; %U = @(r) -(r.^2).*log(r.^2);

im_source = double(im_source);
morphed_im = zeros(sz(1)*sz(2), 3);

[nr, nc, ~] = size(im_source);
[X,Y] = meshgrid(1:nc,1:nr);

[Xb,Yb] = meshgrid(1:sz(2),1:sz(1));
ind_X = Xb(:); ind_Y = Yb(:); 
ind_ss = [ind_X ind_Y];

K_temp = pdist2(ind_ss, ctr_pts);
K = Uspline(K_temp);

P = padarray(ind_ss,[0,1],1,'post');
M = [K P];

Wx =  [w_x; ax_x; ay_x; a1_x];
Wy =  [w_y; ax_y; ay_y; a1_y];
Vx = M*Wx;
Vy = M*Wy;

Vx = max(Vx, 1); Vx = min(Vx, nc);
Vy = max(Vy, 1); Vy = min(Vy, nr);

rep_pts = ctr_pts;
K_ctr_temp = pdist2(rep_pts, ctr_pts);
K_ctr = Uspline(K_ctr_temp);
P_ctr = padarray(rep_pts,[0,1],1,'post');
M_ctr = [K_ctr P_ctr];
Vx_ctr = M_ctr*Wx;
Vy_ctr = M_ctr*Wy;
ctr_pts_morph = [Vx_ctr Vy_ctr];

index = sub2ind(sz, ind_Y, ind_X);
for j = 1:3    
    Vq = interp2(X,Y,im_source(:,:,j),Vx, Vy);
    morphed_im(index,j) = Vq;
end
morphed_im = uint8(reshape(morphed_im,[sz 3]));

end



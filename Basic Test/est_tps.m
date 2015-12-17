function [a1,ax,ay,w] = est_tps(ctr_pts, target_value) %source, target
%ctr_pts is the point positions (x and y) in the image (B) (px2) [itermediate shape]
%target_value is the corresponding point x or y position (px1) in image (A) [original image]
epsilon = 1e-16; %U = @(r) -(r.^2).*log(r.^2);

K_temp = pdist2(ctr_pts, ctr_pts);
K = Uspline(K_temp);

P = padarray(ctr_pts,[0,1],1,'post');
O = zeros(3,3);
M = [K P;P' O];
M = M + epsilon*eye(size(M,1));
V = padarray(target_value,[3,0],0,'post');
results = M\V;

w = results(1:size(ctr_pts,1));
ax = results(end-2); ay = results(end-1); a1 = results(end);
end


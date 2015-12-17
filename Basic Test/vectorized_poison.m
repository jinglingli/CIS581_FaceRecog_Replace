function img_blend = vectorized_poison(src, dst, mask )
%Input: -src: source image
%          -dst: destination image
%          -mask: n x m x 1 mask

%src = im2double(src);
%dst = im2double(dst);
[nr, nc, ~] = size(src); %nr = h; nc = w
[x,y] = meshgrid(1:nc,1:nr);

y_up = y-1;
y_down = y+1;
x_left = x-1;
x_right = x+1;

y_up = min(nr,max(1,y_up)); % keep y_up index within legal range of [1,nr]
y_down = min(nr,max(1,y_down));

x_left = min(nc,max(1,x_left)); % keep x_up index within legal range of [1,nr]
x_right = min(nc,max(1,x_right));

im2var = sub2ind([nr,nc],y(:),x(:));

total = nc*nr;
A = speye(total, total);

laplacian = [0 -1 0; -1 4 -1; 0 -1 0];

ind = im2var(mask(:)==1);
ind_up = sub2ind([nr,nc],y_up(:),x(:)); % create linear index
ind_down = sub2ind([nr,nc],y_down(:),x(:)); 
ind_left = sub2ind([nr,nc],y(:),x_left(:)); 
ind_right = sub2ind([nr,nc],y(:),x_right(:)); 

A(ind, ind_up(ind)) = -1;
A(ind, ind_down(ind)) = -1; 
A(ind, ind_left(ind)) = -1; 
A(ind, ind_right(ind)) = -1;
A(ind, ind) = 4;

res = zeros(nr, nc, 3);

for color = 1:3
    grad = conv2(double(src(:,:,color)), laplacian, 'same');
    dst_temp = dst(:,:,color);
    b = zeros(total, 1);
    b(ind) = grad(ind);
    not_ind = im2var(mask(:)~=1);
    b(not_ind) = dst_temp(not_ind);
    x = A\b;
    x = reshape(x, nr, nc);
    res(:, :, color) = x;
end

img_blend = res;

end


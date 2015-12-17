function img_blend = poisson_blending(src, dst, mask )
%   Input: -src: source image
%          -dst: destination image
%          -mask: n x m x 1 mask

%src = im2double(src);
%dst = im2double(dst);

h = size(src, 1);
w = size(src, 2);
%sz = [w, h];
total = w*h;

im2var = zeros(h, w); 
im2var(1:total) = 1:total; 

A = speye(total, total);

laplacian = [0 -1 0; -1 4 -1; 0 -1 0];
for i = 1:h
    for j = 1:w
        px = im2var(i, j);
        if mask(px)
           A(px, px) = 4;
           A(px, im2var(i+1, j)) = -1;
           A(px, im2var(i-1, j)) = -1;
           A(px, im2var(i, j+1)) = -1;
           A(px, im2var(i, j-1)) = -1;
        end
    end
end

res = zeros(h, w, 3);

for color = 1:3
    grad = conv2(src(:,:,color), laplacian, 'same');
    b = zeros(total, 1);
    for i = 1:h
       for j = 1:w
           px = im2var(i, j);
           if mask(px)
              b(px) = grad(i, j); 
           else
               b(px) = dst(i, j, color);
           end
       end
    end
    x = A\b;
    x = reshape(x, h, w);
    res(:, :, color) = x;
end

img_blend = res;

end


function morphed_im = morph(im1, im2, im1_pts, im2_pts, TRI, warp_frac, dissolve_frac);
if ~isequal(size(im1),size(im2))
    disp('It would be better to keep the size of the two input images be the same.');
    display('Resizing the image now...')
    [im2r, im2c, ~] = size(im2);
    im1 = imresize(im1,[im2r, im2c]);
end

ctr_pts = im2_pts*warp_frac + (1-warp_frac)*im1_pts;

morphed_im = zeros(size(im1,1)*size(im1,2),3);
tri_matrices = cell(size(TRI,1),3);
for i = 1:size(tri_matrices,1)
    tri_matrices{i, 1} = [ctr_pts(TRI(i,:),:)';ones(1,3)]; %matrix for the mid-image (target image)
    tri_matrices{i, 2} = [im1_pts(TRI(i,:),:)';ones(1,3)]; %for image im1
    tri_matrices{i, 3} = [im2_pts(TRI(i,:),:)';ones(1,3)]; %for image im2
end

pad_x = 2; pad_y = 2;
I1 = padarray(im1,[pad_x pad_y],'symmetric');I2 = padarray(im2,[pad_x pad_y],'symmetric');
I1 = double(I1);I2 = double(I2);

[nr, nc, ~] = size(I1);
[X,Y] = meshgrid(1:nc,1:nr);

[nr1, nc1, ~] = size(im1);
[XI,YI] = meshgrid(1:nc1,1:nr1);
ind_XI = XI(:); ind_YI = YI(:); 
t = tsearchn(ctr_pts,TRI,[ind_XI,ind_YI]);

for i = 1:size(TRI,1) 
    index = (t == i); %logical array, i is the ith triangulation
    tgt_i_ind = padarray([ind_XI(index),ind_YI(index)]',[1 0],1,'post');
    barycentric_t = tri_matrices{i,1}\tgt_i_ind; %inv(tri_matrices{t,1})*[XI'; 1]
    Pt1_source = tri_matrices{i, 2}*barycentric_t; Pt2_source = tri_matrices{i, 3}*barycentric_t;

    Pt1_source(1,:) = bsxfun(@rdivide,Pt1_source(1,:),Pt1_source(3,:)); Pt1_source(2,:) = bsxfun(@rdivide,Pt1_source(2,:),Pt1_source(3,:));
    Pt2_source(1,:) = bsxfun(@rdivide,Pt2_source(1,:),Pt2_source(3,:)); Pt2_source(2,:) = bsxfun(@rdivide,Pt2_source(2,:),Pt2_source(3,:));
    
    for j = 1:3
        V1 = interp2(X,Y,I1(:,:,j),Pt1_source(1,:)'+pad_x, Pt1_source(2,:)'+pad_y);
        V2 = interp2(X,Y,I2(:,:,j),Pt2_source(1,:)'+pad_x, Pt2_source(2,:)'+pad_y);
        Vq = V2*dissolve_frac+V1*(1-dissolve_frac);
        morphed_im(index,j) = Vq;
    end
end
morphed_im = uint8(reshape(morphed_im,size(im1)));
%figure;imagesc(morphed_im);
end




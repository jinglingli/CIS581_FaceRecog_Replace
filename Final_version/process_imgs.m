replacement  = 'replacement.jpg'; %your face
im2 = imread(replacement);
replacement_pts = correspondences(replacement);

i = 1;
num_frames = 60; %remember to change for each video
fname = 'medium1_rep2.avi';
h_avi = VideoWriter(fullfile(fname));
h_avi.FrameRate = 20;
h_avi.open();
for i = i:num_frames
    target = sprintf('../Test_images/Medium/Medium1/frame%d.png', i-1);
    target_pts = correspondences(target);
    im1 = imread(target); 
    i
    for j = 1:size(target_pts,1)
        im1_pts = [target_pts{j,1}.x target_pts{j,1}.y];
        im2_pts = [replacement_pts{1,1}.x replacement_pts{1,1}.y];
        if ~isequal(size(im1),size(im2))
            disp('It would be better to keep the size of the two input images be the same.');
            display('Resizing the image now...')
            [im1r, im1c, ~] = size(im1);
            [im2r, im2c, ~] = size(im2);
            im2 = imresize(im2,[im1r, im1c]);   
        end
        im2_pts(:,1) = im2_pts(:,1)*size(im1,2)/im2c;
        im2_pts(:,2) = im2_pts(:,2)*size(im1,1)/im2r;
        img_blend = morph_replace_blend(im1, im2, im1_pts, im2_pts);
        im1 = uint8(img_blend);
    end
    writeVideo(h_avi,uint8(img_blend));
end
close(h_avi);

new_image = zeros(size(im1));
for i=1:3
    new_image(:,:,i) = ~binary_mask.*double(im1(:,:,i))+binary_mask.*double(morphed_im(:,:,i));
end
imagesc(uint8(new_image));

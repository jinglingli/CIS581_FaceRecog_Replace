replacement  = 'replacement.jpg'; %your face
im2 = imread(replacement);
replacement_pts = correspondences(replacement);
im2_pts = [replacement_pts{1,1}.x replacement_pts{1,1}.y];
i = 1;
num_frames = 190; %remember to change for each video
fname = 'medium3_rep_test.avi';
h_avi = VideoWriter(fullfile(fname));
h_avi.FrameRate = 20;
h_avi.open();
for i = i:num_frames
    target = sprintf('../Test_images/Medium/Medium2/frame%d.png', i-1);
    target_pts = correspondences(target);
    im1 = imread(target); 
    i
    if (size(target_pts,1)==0)
        [visiblePoints, im1_pts] = KLT_tracking(prev_pts, prev_im, im1);
        
        %[im2, im2_pts] = findBestfit(im1, im1_pts);
        [im1r, im1c, ~] = size(im1);
        [im2r, im2c, ~] = size(im2);
        if ~isequal(size(im1),size(im2))
            disp('It would be better to keep the size of the two input images be the same.');
            display('Resizing the image now...')
            im2 = imresize(im2,[im1r, im1c]);   
        end
        im2_pts(:,1) = im2_pts(:,1)*size(im1,2)/im2c;
        im2_pts(:,2) = im2_pts(:,2)*size(im1,1)/im2r;
        img_blend = uint8(morph_replace_blend(im1, im2, im1_pts, im2_pts));
        im1 = img_blend;
    end
    for j = 1:size(target_pts,1)
        im1_pts = [target_pts{j,1}.x target_pts{j,1}.y];
        %im2_pts = [replacement_pts{1,1}.x replacement_pts{1,1}.y];
        [im1r, im1c, ~] = size(im1);
        [im2r, im2c, ~] = size(im2);
        if ~isequal(size(im1),size(im2))
            disp('It would be better to keep the size of the two input images be the same.');
            display('Resizing the image now...')
            im2 = imresize(im2,[im1r, im1c]);   
        end
        im2_pts(:,1) = im2_pts(:,1)*size(im1,2)/im2c;
        im2_pts(:,2) = im2_pts(:,2)*size(im1,1)/im2r;
        img_blend = uint8(morph_replace_blend(im1, im2, im1_pts, im2_pts));
        im1 = img_blend;
    end
    prev_pts = im1_pts;
    prev_im = im1;
    writeVideo(h_avi,img_blend);
end
close(h_avi);
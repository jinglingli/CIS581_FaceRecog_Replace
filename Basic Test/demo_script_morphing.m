%% Morphing Android to minion
% Animal to human is at the second section (In case you want to see more dramastic changes)
clear;
im1 = imread('rsz_1android.jpg'); %moving image
im2 = imread('minions_low_res.png'); %fixed image
[im1_pts, im2_pts] = correspondences(im1,im2);

do_trig = 1;
if do_trig
    fname = 'deepak_trig.avi';
else
    fname = 'deepak_tps.avi';
end

% Figure 
h = figure(2); clf;
whitebg(h,[0 0 0]);

try
    % VideoWriter based video creation
    h_avi = VideoWriter(fullfile(fname));
    h_avi.FrameRate = 20;
    h_avi.open();
catch
    % Fallback deprecated avifile based video creation
    h_avi = avifile(fname,'fps',20);
end

mid_pts = (im1_pts+im2_pts)/2;
TRI = delaunay(mid_pts);

for time=linspace(0,1,60)
    warp_frac = time; dissolve_frac = time;
    if (do_trig == 0)
      img_morphed = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac);
    else
      disp(time)
      img_morphed = morph(im1, im2, im1_pts, im2_pts, TRI, warp_frac, dissolve_frac);
    end
    imagesc(img_morphed);
    axis image; axis off;drawnow;
    try
        % VideoWriter based video creation
        writeVideo(h_avi,img_morphed);
    catch
        % Fallback deprecated avifile based video creation
        h_avi = addframe(h_avi, getframe(gcf));
    end
end

try
    % VideoWriter based video creation
    close(h_avi);
catch
    % Fallback deprecated avifile based video creation
    h_avi = close(h_avi);
end

%% Animal to human morphing
clear;
do_trig=0;

im1_animal = imread('Panda_animal_modified.jpg');
im1_human = imread('panda_human.jpg');
im1 = im1_animal;
im2 = im1_human;
load('animal_ctrpts.mat'); load('human_ctrpts.mat');
im1_pts = movingPoints; 
im2_pts = fixedPoints; 

if do_trig
    fname = 'Animal_to_human_trig.avi';
else
    fname = 'Animal_to_human_tps.avi';
end

% Figure 
h = figure(2); clf;
whitebg(h,[0 0 0]);

try
    % VideoWriter based video creation
    h_avi = VideoWriter(fullfile(fname));
    h_avi.FrameRate = 20;
    h_avi.open();
catch
    % Fallback deprecated avifile based video creation
    h_avi = avifile(fname,'fps',20);
end

mid_pts = (im1_pts+im2_pts)/2;
TRI = delaunay(mid_pts);

for time=linspace(0,1,60)
    warp_frac = time; dissolve_frac = time;
    if (do_trig == 0)
      img_morphed = morph_tps_wrapper(im1, im2, im1_pts, im2_pts, warp_frac, dissolve_frac);
    else
      disp(time)
      img_morphed = morph(im1, im2, im1_pts, im2_pts, TRI, warp_frac, dissolve_frac);
    end
    imagesc(img_morphed);
    axis image; axis off;drawnow;
    try
        % VideoWriter based video creation
        writeVideo(h_avi,img_morphed);
    catch
        % Fallback deprecated avifile based video creation
        h_avi = addframe(h_avi, getframe(gcf));
    end
end

try
    % VideoWriter based video creation
    close(h_avi);
catch
    % Fallback deprecated avifile based video creation
    h_avi = close(h_avi);
end

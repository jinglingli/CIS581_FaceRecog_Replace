v = VideoReader('../Anchorman.mp4');
i = 0;
while hasFrame(v)
    video = readFrame(v);
    filename = sprintf('./Extract_imgs/frame%d.png', i);
    imwrite(video,filename);
    i = i+1;
end
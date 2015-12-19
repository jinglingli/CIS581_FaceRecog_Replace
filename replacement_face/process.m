%%quickly process 

[x,y] = textread('30.txt',' %s %s');
pts = zeros(size(x,1),2);
for i = 1:size(x,1)
    pts(i, 1) = str2num(x{i});
    pts(i, 2) = str2num(y{i});
end

im_show = imread('90.jpg');
load('90.mat');

figure;
imshow(im_show);
hold on;
ind = pts(:,1)>0;
scatter(pts(ind, 1), pts(ind, 2), 'g.');
hold off;


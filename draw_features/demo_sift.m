addpath(genpath('../graphs/altmany-export_fig-113e357'));
f = figure,hold on;
image1 = './626.jpg';
[im1, des1, loc1] = sift(image1);
im1 = imread(image1);
imshow(im1);
hold on;
scatter(loc1(:,2), loc1(:,1));
print2eps('sift_points',f);
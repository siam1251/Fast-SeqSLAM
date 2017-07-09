image1 = '../270.jpg';
[im1, des1, loc1] = sift(image1);
im1 = imread(image1);
imshow(im1);
hold on;
scatter(loc1(:,2), loc1(:,1));
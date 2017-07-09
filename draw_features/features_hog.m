addpath(genpath('../graphs/altmany-export_fig-113e357'));
f = figure,hold on;
img = imread('626.jpg');
[featureVector,hogVisualization] = extractHOGFeatures(img,'CellSize',[64,64],'NumBins',9);

imshow(img);
hold on;
plot(hogVisualization);
print2eps('hog_points',f);
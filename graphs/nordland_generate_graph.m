clear all;
close all;
path = 'prcurves/nordland/'
addpath(genpath('altmany-export_fig-113e357'));
cols = [200 45 43; 37 64 180; 0 176 80; 0 0 0;212 200 144]/255;
f = figure,hold on;


p1 = load(strcat(path,'no_mutual_prcurve_nordland_ds100_gray1_resize1_N100.mat'));
plot(p1.points(1,:),p1.points(2,:),'color', cols(1,:), 'linewidth', 2);
hold on;
p5 = load(strcat(path,'no_mutual_no_hog_prcurve_nordland_ds100_gray1_resize1_N100.mat'));
plot(p5.points(1,:),p5.points(2,:),'color', cols(3,:), 'linewidth', 2);
hold on;
p2 = load(strcat(path,'prcurve_nordland_ds100_gray1_resize1_Contrast1.mat'));
plot(p2.points(1,:),p2.points(2,:),'color', cols(2,:), 'linewidth', 2);
hold on;
% p3 = load(strcat(path,'no_hog_prcurve_nordland_ds100_gray1_resize1_N100.mat'));
% plot(p3.points(1,:),p3.points(2,:),'color', cols(3,:), 'linewidth', 2);
% hold on;
% p4 = load(strcat(path,'prcurve_nordland_ds100_gray1_resize1_Contrast0.mat'));
% plot(p4.points(1,:),p4.points(2,:),'color', cols(4,:), 'linewidth', 2);
% hold on;

axis([0 1 .7 1]);
set(gca, 'box', 'on');
h = legend('Fast-SeqSLAM with HOG','Fast-SeqSLAM with raw image',...
    'SeqSlam');

xlabel('recall'); ylabel('precision');
set(gca, 'box', 'on');
set(h, 'position',[.47 0.2 .1 .1])

%f = gcf;
print2eps('nordland_spring_winter',f)
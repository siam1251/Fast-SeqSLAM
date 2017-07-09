clear all;
path = strcat('../UofA day_evening ANN sparse matrix modifiedfindmatches alderley dataset changed parameter/', ...
'prcurve/prcurve_original_day_evening_ds30_gray1_resize1_N100.mat');
path
addpath(genpath('altmany-export_fig-113e357'));
cols = [200 45 43; 37 64 180; 0 176 80; 0 0 0;212 200 144]/255;
f = figure,hold on;


p1 = load(path);
plot(p1.points(1,:),p1.points(2,:),'color', cols(1,:), 'linewidth', 2);
hold on;
p2 = load('../original/prcurve/prcurve_original_day_evening_ds30_gray1_resize1.mat');
plot(p2.points(1,:),p2.points(2,:),'color', cols(2,:), 'linewidth', 2);
axis([0 1 0 1]);
xlabel('TPR (recall)'); ylabel('PPV (precision)'); title('PR curves');
set(gca, 'box', 'on');
h = legend('our algorithm','SeqSlam');
set(h, 'position',[.5 0.2 .1 .1])
title('uofa day evening');
print2eps('uofa_day_evening',f)
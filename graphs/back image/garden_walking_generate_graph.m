path = strcat('../Garden walking ANN sparse matrix modifiedfindmatches default dataset changed parameter/', ...
'prcurve/prcurve_garden_ds20_gray1_resize1_N15.mat');
path

cols = [200 45 43; 37 64 180; 0 176 80; 0 0 0]/255;
f = figure,hold on;


p1 = load(path);
plot(p1.points(1,:),p1.points(2,:),'color', cols(1,:), 'linewidth', 2);
hold on;
p2 = load('../original/prcurve/prcurve_garden_ds20_gray1_resize1.mat');
plot(p2.points(1,:),p2.points(2,:),'color', cols(2,:), 'linewidth', 2);
axis([0 1 0 1]);
xlabel('TPR (recall)'); ylabel('PPV (precision)'); title('PR curves');
set(gca, 'box', 'on');
h = legend('our algorithm','SeqSlam');
set(h, 'position',[.5 0.2 .1 .1])
title('garden walking dataset');
print2eps('garden',f)
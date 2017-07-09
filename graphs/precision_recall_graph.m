close all;
addpath(genpath('altmany-export_fig-113e357'));
cols = [200 45 43;  0 176 80;37 64 180; 0 0 0]/255;
red = cols(1,:);
green = cols(2,:);
blue = cols(3,:);
f = figure,hold on;
width = 2.5;
%nordland dataset
p1 = load('prcurves/prcurve_nordland_ds100_gray1_resize1_Contrast1.mat');
a1 = plot(p1.points(1,:),p1.points(2,:),'--','color', red, 'linewidth', width);
M1 = 'Nordland'

hold on;
p2 = load('prcurves/prcurve_nordland_ds100_gray1_resize1_N100.mat');
a2 = plot(p2.points(1,:),p2.points(2,:),'color', red, 'linewidth', width);
M2 = 'Nordland';


hold on;
%legend('SeqSlam','our algorithm');

%garden dataset
p1 = load('prcurves/prcurve_garden_ds20_gray1_resize1.mat');
plot(p1.points(1,:),p1.points(2,:),'--','color', green, 'linewidth', width);
hold on;
p2 = load('prcurves/prcurve_garden_ds20_gray1_resize1_N10.mat');
plot(p2.points(1,:),p2.points(2,:),'color', green, 'linewidth', width);
hold on;
%day_evening dataset
p1 = load('prcurves/prcurve_original_day_evening_ds20_gray1_resize1.mat');
plot(p1.points(1,:),p1.points(2,:),'--','color', blue, 'linewidth', width);
hold on;
p2 = load('prcurves/prcurve_original_day_evening_ds20_gray1_resize1_N20.mat');
plot(p2.points(1,:),p2.points(2,:),'color', blue, 'linewidth', width);
hold on;
%h = legend('SeqSlam','our algorithm');


axis([0 1 .5 1]);
xlabel('recall'); ylabel('precision'); 
set(gca, 'box', 'on');

%set(h1, 'position',[.3,0.3,0.2,0.2])
%title('Precision Recall Curve');
print2eps('precision_recall',f)

path = 'prcurves/uofa/'
addpath(genpath('altmany-export_fig-113e357'));
cols = [200 45 43; 37 64 180; 0 176 80; 0 0 0;212 200 144]/255;
f = figure,hold on;
width = 2;
style = '-';
p1 = load(strcat(path,'prcurve_U0fA_day_evening_ds30_gray1_resize1_N30.mat'));
plot(p1.points(1,:),p1.points(2,:),style,'color', cols(1,:), 'linewidth',width);
hold on;
p5 = load(strcat(path,'no_hog_prcurve_U0fA_day_evening_ds30_gray1_resize1_N10.mat'));
plot(p5.points(1,:),p5.points(2,:),'color', cols(3,:), 'linewidth', 2);
hold on;
p2 = load(strcat(path,'prcurve_original_day_evening_ds20_gray1_resize1.mat'));
plot(p2.points(1,:),p2.points(2,:),style,'color', cols(2,:), 'linewidth',width);
hold on;
% p3 = load(strcat(path,'no_hog_prcurve_U0fA_day_evening_ds20_gray1_resize1_N30.mat'));
% plot(p3.points(1,:),p3.points(2,:),style,'color', cols(3,:), 'linewidth',width);
% hold on;
% p4 = load(strcat(path,'prcurve_original_day_evening_ds30_gray1_resize1_contrast_0_R_10.mat'));
% plot(p4.points(1,:),p4.points(2,:),style,'color', cols(4,:), 'linewidth',width);
% hold on;

axis([0 1 .5 1]);

set(gca, 'box', 'on');
h = legend('Fast-SeqSLAM with HOG','Fast-SeqSLAM with raw image',...
    'SeqSlam');
axis([0 1 .7 1]);
xlabel('recall'); ylabel('precision'); title('PR curves');
set(gca, 'box', 'on');

set(h, 'position',[.47 0.2 .1 .1])%, 'FontSize',12);

%f = gcf;
print2eps('uofa_day_evening',f)
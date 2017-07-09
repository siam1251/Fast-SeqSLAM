clear all;
close all;
time_ann = dlmread('time/ANN_8_8_.9_32_32.1-10.txt');
time_original = dlmread('time/original8_8_.9_32_32.1-10.txt');
tm_ann = zeros(length(time_ann),2);
tm_original = zeros(length(time_ann),2);
total = 35700;
for i=1:length(time_ann)
    tm_ann(i,:) = [ total/time_ann(i,2),sum(time_ann(i,3:6))];
    tm_original(i,:) = [ total/time_original(i,2), sum(time_original(i,3:6))];
end

addpath(genpath('altmany-export_fig-113e357'));
cols = [200 45 43;  0 176 80;37 64 180; 0 0 0]/255;
f = figure();
hold on;
start = 1;
plot(tm_ann(start:start+9,1),tm_ann(start:start+9,2),'ro-','color', cols(1,:), 'linewidth', 2);
hold on;
plot(tm_original(start:start+9,1),tm_original(start:start+9,2),'ro-','color', cols(3,:), 'linewidth', 2);
hold on;
h1 = legend('Fast-SeqSLAM','SeqSLAM');
legend boxoff ;
set(h1, 'position',[.2,0.2,0.2,0.2]);
xlabel('Number of images'); ylabel('Execution time (seconds)'); 
set(gca, 'box', 'on');
print2eps('execution_time',f);
tm_ann(1:10,2)
tm_original(1:10,2)
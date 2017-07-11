%% first set the parameters

    clear all;
    tic;
    % start with default parameters
    params = defaultParameters();    
    addpath(genpath('../fast_seqSlam'));
     % 
   
    ds.name = 'evening';
    ds.imageSkip = 1;     % use every n-nth image
    ds.imagePath = '../../datasets/UofA_dataset/day_evening/evening'; 
    ds.imageIndices = 1:ds.imageSkip:645;     
    ds.numberFormat = 1;
    ds.prefix='';
    ds.cellSize = [8, 8];
    ds.extension='.jpg';
    ds.suffix='';
    
    
    ds.savePath = 'results';
    ds.saveFile = sprintf('%s-%d-%d-%d', ds.name, ds.imageIndices(1), ds.imageSkip, ds.imageIndices(end));
    
    ds.preprocessing.save = 1;
    ds.preprocessing.load = 1;
    % load old results or re-calculate?
    params.differenceMatrix.save = 1;
    params.differenceMatrix.load = 0;
    params.contrastEnhanced.load = 0;
    
    params.matching.load = 0;
    %ds.crop=[1 1 60 32];  % x0 y0 x1 y1  cropping will be done AFTER resizing!
    ds.crop=[];
    
    spring=ds;


    % 
    ds.name = 'day';
    ds.imagePath = '../../datasets/UofA_dataset/day_evening/day';   
    %ds.imageIndices = 1:ds.imageSkip:1640;     
          
    ds.saveFile = sprintf('%s-%d-%d-%d', ds.name, ds.imageIndices(1), ds.imageSkip, ds.imageIndices(end));
    % ds.crop=[5 1 64 32];
    ds.crop=[];
    
    winter=ds;        

    params.dataset(1) = spring;
    params.dataset(2) = winter;

    
    
    % where to save / load the results
    params.savePath='results';
              
    
%% now process the dataset
   
    results = openSeqSLAM(params);      
    timeSpent = toc;
    
%% show some results
    
    close all;
    % set(0, 'DefaultFigureColor', 'white');
    
    % Now results.matches(:,1) are the matched winter images for every 
    % frame from the spring dataset.
    % results.matches(:,2) are the matching score 0<= score <=1
    % The LARGER the score, the WEAKER the match.
    
    m = results.matches(:,1);
    %ploting precision recall graph
    targs = 1:length(results.matches);
    range = 4;
    filename = sprintf('prcurve_original_day_evening_ds%s_gray%s_resize%s_N%s.mat',num2str(params.matching.ds), ...
    num2str(params.DO_GRAYLEVEL), ...
    num2str(params.DO_RESIZE ), ...
    num2str(params.N));   
    showPrecisionCurve(results.matches,targs,range,params.dataset(1).imageSkip,filename);
    
    results.matches
    mean_value = mean(results.matches(:,2));
    im = results.D;
    %im = flipud(im);
    %im= im*255/params.initial_distance;
    figure, imagesc(im);
    set(gca,'Ydir','normal');
    mean_value
    thresh=.95;  % you can calculate a precision-recall plot by varying this threshold
    m(results.matches(:,2)>thresh) = NaN;  % remove the weakest matches
    figure,plot(m,'.');      % ideally, this would only be the diagonal
    xlabel(params.dataset(2).name);
    ylabel(params.dataset(1).name);
    title('Matchings'); 
    results.timeSpent

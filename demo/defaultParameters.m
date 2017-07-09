% 

% 

function params=defaultParameters()



    % switches
    params.DO_PREPROCESSING = 1;
    params.DO_RESIZE        = 1;
    params.DO_GRAYLEVEL     = 1;
    params.DO_PATCHNORMALIZATION    = 0;
    params.DO_SAVE_PREPROCESSED_IMG = 1;
    params.DO_DIFF_MATRIX   = 1;
    params.DO_CONTRAST_ENHANCEMENT  = 0;%make it 0!!
    params.DO_FIND_MATCHES  = 1;

    %parameters for Flann and building similarity matrix
    params.N = 10;
    params.initial_distance = 9999;
    params.mul_unit = 2;
    %%ANN parameters
    params.distance_type = 'manhattan';
    params.algorithm = 'kdtree';
    params.trees = 8;
    params.checks = 64;

    % parameters for preprocessing
    params.downsample.size = [32 32];  % height, width
    params.downsample.method = 'lanczos3';
    params.normalization.sideLength = 8;
    params.normalization.mode = 1;
            
    
    % parameters regarding the matching between images
    params.matching.ds = 30; %always even number
    %params.matching.seqMaxValue = params.initial_distance*(params.matching.ds+1);
    params.thresh = .90;
    params.matching.Rrecent=5;
    params.matching.vmin = .8;
    %params.matching.vskip = 0.1;
    params.matching.vmax = 1.2;  
    params.matching.Rwindow = 10;
    params.matching.save = 1;
    params.matching.load = 1;
    
    % parameters for contrast enhancement on difference matrix  
    params.contrastEnhancement.R = 10;

    % load old results or re-calculate? save results?
    params.differenceMatrix.save = 0;
    params.differenceMatrix.load = 0;
    
    params.contrastEnhanced.save = 1;
    params.contrastEnhanced.load = 0;
    
    % suffix appended on files containing the results
    params.saveSuffix='';

end
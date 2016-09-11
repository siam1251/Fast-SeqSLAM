%

% 
function results = doDifferenceMatrix(results, params)
    
    addpath(genpath('./flann'));
    filename = sprintf('%s/difference-%s-%s%s.mat', params.savePath, params.dataset(1).saveFile, params.dataset(2).saveFile, params.saveSuffix);  
    tic;
    if params.differenceMatrix.load && exist(filename, 'file')
        display(sprintf('Loading image difference matrix from file %s ...', filename));

        d = load(filename);
        results.D = d.D;                                    
    else
        if length(results.dataset)<2
            display('Error: Cannot calculate difference matrix with less than 2 datasets.');
            return;
        end

        display('Calculating image difference matrix ...');
  %      h_waitbar = waitbar(0,'Calculating image difference matrix');

        dhog1 = results.dataset(1).preprocessing;
        dhog2 = results.dataset(2).preprocessing;

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%calcualtion of similarity matrix using FLANN nearest neighbour%%%%%%%%%%%%%%%%%%%%%%%%
        flann_set_distance_type(params.distance_type,  0);

        N = params.N;
        [index1, search_params1,speedup ] = flann_build_index(dhog1, struct('algorithm',params.algorithm, 'target_precision',...
         params.target_precision));%, 'trees',params.trees));                                             
%        
%         [index1, search_params1 ] = flann_build_index(dhog1, struct('algorithm','linear'...
%                                                                   ));                                             
        toc
        [result1, ndists1] = flann_search(index1, dhog2, N, search_params1);


        result1 = result1';
        ndists1 = ndists1';
        d1 = ndists1(:);
        tmp = [1: length(result1)]';
        column1 = repmat(tmp, N, 1);


        column2 = result1(:);
        size(column2)
        S1 = table(column1, column2);
        %S1

        '------------'

        %% cross check
        [index2, search_params2, speedup ] = flann_build_index(dhog2, struct('algorithm',params.algorithm,'target_precision',...
         params.target_precision));%, 'trees',params.trees));  
        results.speedup = speedup;
        %         [index2, search_params2 ] = flann_build_index(dhog2, struct('algorithm','linear', 'trees',8,...
%       s0e                                                            'checks',64));  
		
        [result2, ndists2] = flann_search(index2, dhog1, N, search_params2);
        toc
        %result2 contains nodes of M2 for each node 1, 2, 3, .. of M1
        %result1 contains nodes of M1 for each node 1, 2, 3, .. of M2
        result2 = result2';
        ndists2 = ndists2';
        d2 = ndists2(:);
        tmp = [1: length(result2)]';
        column2 = repmat(tmp, N, 1);


        column1 = result2(:);
        
        S2 = table(column1, column2);
        
        
        
        [S, i1, i2] = intersect(S1, S2);
        %S = (N1_i, N2_j)
        S_arr = table2array(S);
        %[S_arr d1(i1)]
        ini_dist = params.initial_distance;
        similarity_matrix = (-ini_dist)*ones(length(result1), length(result2));
        %S_arr(:,1) = nodes from map 2
        %S_arr(:,2) = nodes from map 1
        %    --------M2----------
        %    |  4 0 0 0 0 0
        %    |  1 0 0 0 0 0
        % S= M1 0 0 0 3 0 0
        %    |  0 4 0 0 0 0
        %    |  0 0 2 0 0 0
        %    |  0 1 0 0 0 0
        

        ind = sub2ind(size(similarity_matrix), S_arr(:,1), S_arr(:,2));
        %similarity_matrix(ind) = 30;
        %[S_arr d1(i1)]
        %ind = sub2ind(size(similarity_matrix), S_arr(:,2), S_arr(:,1));
        similarity_matrix(ind) = (d1(i1) + d2(i2))/2;
        %%%%fill the values by max value
        max_val = max(similarity_matrix(:));
       
        
        similarity_matrix(similarity_matrix == -params.initial_distance) = params.mul_unit*max_val;
        
        %params.matching.seqMaxValue = params.mul_unit*max_val*(params.matching.ds+1);
        D = similarity_matrix;
        D = D';
        
        %%%%%%%%calculation of similarity matrix%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        results.D=D;
         %    --------M1----------
        %    |  4 0 0 0 0 0
        %    |  1 0 0 0 0 0
        % S= M2 0 0 0 3 0 0
        %    |  0 4 0 0 0 0
        %    |  0 0 2 0 0 0
        %    |  0 1 0 0 0 0

        % save it
        if params.differenceMatrix.save                   
            save(filename, 'D');
        end
        toc

     %   close(h_waitbar);
    end    


end

%

%      
function results = doFindMatchesModified(results, params)       
    filename = sprintf('%s/matches-%s-%s%s.mat', params.savePath, params.dataset(1).saveFile, params.dataset(2).saveFile, params.saveSuffix);  
     
    if params.matching.load && exist(filename, 'file')
        display(sprintf('Loading matchings from file %s ...', filename));
        m = load(filename);
        results.matches = m.matches;  
        results.seqValues = m.seqValues;        
    else
    
        %matches = NaN(size(results.DD,2),2);
        
        display('Searching for matching images ...');
        % h_waitbar = waitbar(0, 'Searching for matching images.');
        
        % make sure ds is dividable by two
        params.matching.ds = params.matching.ds + mod(params.matching.ds,2);
        
        
        [matches, seqValues] = findMatchingMatrix(results, params);
               
        % save it
        if params.matching.save
            save(filename, 'matches','seqValues');
        end
        
        results.matches = matches;
        results.seqValues = seqValues;% for debugging purpose
        
        
    end
end

function [matches, seqValues] = findMatchingMatrix(results, params)
    
    DD = (results.DD);
    max_val = max(DD(:));
    
    seqMaxValue = max_val*(params.matching.ds+1);
    % We shall search for matches using velocities between
    % params.matching.vmin and params.matching.vmax.
    % However, not every vskip may be neccessary to check. So we first find
    % out, which v leads to different trajectories:
        
    move_min = params.matching.vmin * params.matching.ds;    
    move_max = params.matching.vmax * params.matching.ds;    
    
    move = move_min:move_max;
    v = move / params.matching.ds;
    %adding velocity 1 will go in the next location if
    % since all the trajectories will have same difference score
    % and it will return the first one
    v = [1, v];
    %v(1) = 1
    ds = params.matching.ds;
    idy_add = repmat([-ds:0], size(v,2),1);
   
   % idy_add is y axis indices
   %   -1 0 1
   %    0 0 1
   %   -1 -1 0
   %
   length(idy_add)
    idy_add = round(idy_add .* repmat(v', 1, size(idy_add,2)));
    
     
    
    
    %score = zeros(2,size(DD,1));    
    
    % add a line of inf costs so that we penalize running out of data
    
    
    
    %score = zeros(1,size(DD,1));  
    %[id, vls] = min(DD);
    
   
    %row padding
    DD=[DD];
    num_cols = size(DD,2);
    row_padding = ones(ds,num_cols)*max_val;
    
    DD=[row_padding;DD];
    %col padding
    %col padding is 1 more than ds/2 because if we have higher velcity than
    %1 then it will create problem
    num_rows = size(DD,1);
    col_padding = ones(num_rows,ds);
    DD = [col_padding, DD];


    maxRow = size(DD,1);
    maxCol = size(DD,2);
    
    
    matchingMatrix = ones(size(DD))*seqMaxValue;
    y_max = size(DD,1);  
   
    % [sortedValues,sortIndex] = sort(results.DD,'ascend'); 
    % max_index = 5;
    next_states = [];
   
    if params.N < params.K
        K = params.N
    else
    	K =params.K
    end
    for Col = 2*ds : size(DD,2)
        % this is where our trajectory starts
        % n_start = Col - ds/2;
        % %x  is in x axis indices, 
        % x= repmat([n_start : n_start+ds], length(v), 1);  
        %indices = find(DD(:,Col) < max_val);
        
        %indices of n lowest values in a column
        [sortedValues,sortIndex] = sort(DD(:,Col),'ascend');  %# Sort the values in increasing order
        indices = sortIndex(1:K);  %# Get a linear index into A of the smallest values
        
        indices = union(indices,next_states);
        if size(indices,1) > 1
        	indices = indices';
        end
        %indices = sortIndex(1:10);
        %lf = find(DD(:,Col) > params.initial_distance)
      
        next_states = [];
        for Row=indices
           
        
            if Col > maxCol || Row > maxRow
                break;
            end
            % score is zero for entering in the while loop
            if matchingMatrix(Row,Col) < seqMaxValue
                continue;
            end
            score = 0;
        
            n_start = Col;
            %x  is in x axis indices, or column indices
            x= repmat([n_start-ds : n_start], length(v), 1);  
            xx = (x-1) * y_max;

            %row indices
            y = min(idy_add+Row, y_max);   
            %adding row indices and column indices
            idy = xx + y;
            
            [score, velocity_index] = min(sum(DD(idy),2));
            %idy = indices are always accessed row wise
            %Since we made the indices using colunm by column or assume
            %indices will be column by column,
            %in sum function, for option 2, column wise indices summation
            %otherwise row wise indices summation
            %matchingMatrix(R,C) = score;
            
            
            matchingMatrix(Row,Col) = score;
                %DD(R,C) = score/(ds+1);
                %[R,C,score,velocity_index]
            
            %current_velocity = v(velocity_index);
            %matchingMatrix
            
            R = Row + idy_add(velocity_index,ds+1)-idy_add(velocity_index,ds);
            if score < seqMaxValue
                next_states = [next_states; R];
            end
           
            
        
            
        end
            %   waitbar(N / size(results.DD,2), h_waitbar);
        %break;
        
    end
    
    %normA = matchingMatrix - min(matchingMatrix(:));
    %normA = normA ./ max(normA(:)) %
    %figure, imshow(normA);
    %matchingMatrix = normc(matchingMatrix);
    %[scores, id] = min(matchingMatrix)
    %matches = [id'+params.matching.ds/2, scores'];

    %give up the padding of machingMatrix
    %since col padding was 1 more than ds/2 
    matchingMatrix = matchingMatrix(ds+1:end,ds+1:end);
    matches = NaN(size(matchingMatrix,2),2);
    for Col = 1: size(matchingMatrix,2)

        score= matchingMatrix(1:end,Col);
        %score = normc(score);
        [min_value, min_idx] = min(score);
        window = max(1, min_idx-params.matching.Rwindow/2):min(length(score), min_idx+params.matching.Rwindow/2);
        not_window = setxor(1:length(score), window);
        min_value_2nd = min(score(not_window));
        if min_value >= seqMaxValue
            min_idx = NaN;
        end
        matches(Col,:) = [min_idx; min_value/min_value_2nd ]; 
        %if min_value < params.matching.seqMaxValue
        %   matches(Col,:) = [min_idx ; min_value]; 
        %end
    end
    seqValues = matchingMatrix;
end

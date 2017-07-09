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
    %v(1) = 1
    ds = params.matching.ds;
    idy_add = repmat([-ds/2:ds/2], size(v,2),1);
   
   % idy_add is y axis indices
   %   -1 0 1
   %    0 0 1
   %   -1 -1 0
   %
   length(idy_add)
    idy_add = floor(idy_add .* repmat(v', 1, size(idy_add,2)));
    
     
    
    
    %score = zeros(2,size(DD,1));    
    
    % add a line of inf costs so that we penalize running out of data
    
    
    
    %score = zeros(1,size(DD,1));  
    %[id, vls] = min(DD);
    
   
    %row padding
    DD=[DD];
    num_cols = size(DD,2);
    row_padding = ones(ds/2,num_cols)*max_val;
    
    DD=[row_padding;DD;row_padding];
    %col padding
    %col padding is 1 more than ds/2 because if we have higher velcity than
    %1 then it will create problem
    num_rows = size(DD,1);
    col_padding = ones(num_rows,1+ds/2);
    DD = [col_padding, DD, col_padding];


    maxRow = size(DD,1);
    
    
    matchingMatrix = ones(size(DD))*seqMaxValue;
    y_max = size(DD,1);  
   
    % [sortedValues,sortIndex] = sort(results.DD,'ascend'); 
    % max_index = 5;

    for Col = 2+ds/2 : size(DD,2)-1-ds/2
        % this is where our trajectory starts
        % n_start = Col - ds/2;
        % %x  is in x axis indices, 
        % x= repmat([n_start : n_start+ds], length(v), 1);  
        indices = find(DD(:,Col) < max_val);
        
        %indices of n lowest values in a column
        [sortedValues,sortIndex] = sort(DD(:,Col),'ascend');  %# Sort the values in increasing order
        indices = intersect(indices,sortIndex(1:10));  %# Get a linear index into A of the smallest values
        %indices = sortIndex(1:10);
        %lf = find(DD(:,Col) > params.initial_distance)
        
        for Row=indices'
            C = Col;
            R = Row;
            % score is zero for entering in the while loop
            if matchingMatrix(R,C) < seqMaxValue
                continue;
            end
            score = 0;
            while score < seqMaxValue % at least 1-.x
                %score = findSingleMatch(DD,x,idy_add,y_max, Col,Row, params);
                % if matchingMatrix(R,C) < seqMaxValue
                %     break;
                % end
                if C > size(DD,2)-ds/2|| R > size(DD,1)-ds/2||C < ds/2
                    break;
                end
                n_start = C;
                %x  is in x axis indices, or column indices
                x= repmat([n_start-ds/2 : n_start+ds/2], length(v), 1);  
                xx = (x-1) * y_max;

                %row indices
                y = min(idy_add+R, y_max);   
                %adding row indices and column indices
                idy = xx + y;
                
                [score, velocity_index] = min(sum(DD(idy),2));
                %idy = indices are always accessed row wise
                %Since we made the indices using colunm by column or assume
                %indices will be column by column,
                %in sum function, for option 2, column wise indices summation
                %otherwise row wise indices summation
                %matchingMatrix(R,C) = score;
                
                if matchingMatrix(R,C) > score
                    matchingMatrix(R,C) = score;
                    %DD(R,C) = score/(ds+1);
                    %[R,C,score,velocity_index]
                else
                    break;
                end
                %current_velocity = v(velocity_index);
                %matchingMatrix
                C = C+1;
                R = R + idy_add(velocity_index,2+ds/2)-idy_add(velocity_index,1+ds/2);
                
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
    matchingMatrix = matchingMatrix(1+ds/2:end-ds/2,2+ds/2:end-1-ds/2);
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

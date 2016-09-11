function results = doContrastEnhancement(results, params)
        
    filename = sprintf('%s/differenceEnhanced-%s-%s%s.mat', params.savePath, params.dataset(1).saveFile, params.dataset(2).saveFile, params.saveSuffix);  
    
    if params.contrastEnhanced.load && exist(filename, 'file')                
        display(sprintf('Loading contrast-enhanced image distance matrix from file %s ...', filename));
        dd = load(filename);
        results.DD = dd.DD;

    else

        display('Performing local contrast enhancement on difference matrix ...');
    %    h_waitbar = waitbar(0,'Local contrast enhancement on difference matrix');

        DD = zeros(size(results.D), 'single');

        D=results.D;
        parfor i = 1:size(results.D,1)
            a=max(1, i-params.contrastEnhancement.R/2);
            b=min(size(D,1), i+params.contrastEnhancement.R/2);                                                        
            v = D(a:b, :);
            DD(i,:) = (D(i,:) - mean(v)) ./ std(v);                                          
           % waitbar(i/size(results.D, 1));                
        end  
                      
        % let the minimum distance be 0
        results.DD = DD-min(min(DD));

        % save it?
        if params.contrastEnhanced.save                         
            DD = results.DD;
            save(filename, 'DD');
        end

  %      close(h_waitbar);

    end

end
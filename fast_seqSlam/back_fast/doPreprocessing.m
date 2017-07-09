%


function results = doPreprocessing(params)
    for i = 1:length(params.dataset)

        % shall we just load it?
        filename = sprintf('%s/preprocessing-%s%s.mat', params.dataset(i).savePath, params.dataset(i).saveFile, params.saveSuffix);                
        if params.dataset(i).preprocessing.load && exist(filename, 'file');           
            r = load(filename);
            display(sprintf('Loading file %s ...', filename));
            results.dataset(i).preprocessing = r.results_preprocessing;
        else
            % or shall we actually calculate it?
            p = params;    
            p.dataset=params.dataset(i);
            results.dataset(i).preprocessing = single(preprocessing(p));

            if params.dataset(i).preprocessing.save                
                results_preprocessing = single(results.dataset(i).preprocessing);
                save(filename, 'results_preprocessing');
            end                
        end
    end               
end





%%
function dhog = preprocessing(params)
    

    display(sprintf('Preprocessing dataset %s, indices %d - %d ...', params.dataset.name, params.dataset.imageIndices(1), params.dataset.imageIndices(end)));
   % h_waitbar = waitbar(0,sprintf('Preprocessing dataset %s, indices %d - %d ...', params.dataset.name, params.dataset.imageIndices(1), params.dataset.imageIndices(end)));
    
    % allocate memory for all the processed images
    %     n = length(params.dataset.imageIndices);
    %     m = params.downsample.size(1)*params.downsample.size(2); 
    %     
    %     if ~isempty(params.dataset.crop)
    %         c = params.dataset.crop;
    %         m = (c(3)-c(1)+1) * (c(4)-c(2)+1);
    %     end
    %     
    %     images = zeros(m,n, 'uint8');
    %     j=1;
    l = length( params.dataset.imageIndices);
    dhog = []*l;
    readFormat = strcat('%s/%s%0',num2str(params.dataset.numberFormat),'d%s%s')
   
    % for every image ....
    indices = params.dataset.imageIndices;
    j = 1;
    for i = indices
        filename = sprintf(readFormat, params.dataset.imagePath, ...
            params.dataset.prefix, ...
            i, ...
            params.dataset.suffix, ...
            params.dataset.extension);
        
        
        
        
       
        
        
        im = imread(filename);
        % convert to grayscale
        if params.DO_GRAYLEVEL
            im = rgb2gray(im);
        end
        
        % resize the image
        if params.DO_RESIZE
            im = imresize(im, params.downsample.size, params.downsample.method);
        end
        % do patch normalization
        % it didn't work well with hog descriptor
        if params.DO_PATCHNORMALIZATION
          im = patchNormalize(im, params);            
        end
        
        
       
      
        [d, visualization] = extractHOGFeatures(im,'CellSize',params.dataset.cellSize);
        dhog(j,:)= d(:);
        j=j+1;
       % waitbar((i-params.dataset.imageIndices(1)) / (params.dataset.imageIndices(end)-params.dataset.imageIndices(1)));
        
    end
    dhog = dhog';
   % close(h_waitbar);
    size(dhog)
end




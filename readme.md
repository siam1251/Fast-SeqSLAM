
% Copyright 2016, Sayem Mohammad Siam
% siam@ualberta.ca
% Modified the original code of  Niko Sünderhauf which can be found https://openslam.org/openseqslam.html
% The functions doProcessing, doFindMatches (doFindMatchesModified), doDifferenceMatrix, DefaultParameters are mainly modified.
% Other than this files, some parameters of the other files are modified.
% I used Flann libray for the Approximate nearest neighbour calculation.
% didn't implement the matching computation in the doFindMatchesModifed parallely so it may take longer time than the original
% seqSlam implementation which has implemented matching computation parallely

% This file is basically modified part of OpenSeqSLAM.
%
% OpenSeqSLAM is free software: you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation, either version 3 of the License, or
% (at your option) any later version.
% 
% 
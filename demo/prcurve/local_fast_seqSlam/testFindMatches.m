addpath(genpath('./seqSlam'));
load params;    
params.thresh = 3*2.6/3;
%results.DD = results.DD(300:600,300:600);
params.matching.vmin = 0.4;
params.matching.vmax = 1.8;
params.matching.ds = 4; 
results.DD = [
    0,    58,    69,    80,     1,    12,    23,    34,    45;
    57,    3,    79,     9,    11,    22,    33,    44,    46;
    67,    78,     7,    10,    21,    32,    43,    54,    56;
    77,     7,    18,    0,    31,    42,    53,    55,    66;
     6,    17,    19,    30,    0,    2,    63,    65,    76;
    16,    27,    29,    40,    51,    0,    64,    75,     5;
    26,    28,    39,    50,    61,    72,    0,     4,    15;
    36,    38,    49,    60,    71,    73,     3,    0,    25;
    37,    48,    59,    70,    81,     2,    13,    24,    0;]

results.DD(results.DD>10) = 9999;
%results.DD

results = doFindMatchesModified(results,params);
m = results.matches(:,1);
disp('-------------------');
size(m)
%thresh=1;  % you can calculate a precision-recall plot by varying this threshold
%m(results.matches(:,2)>params.thresh) = NaN;  % remove the weakest matches
%
%building constraints as a single map
% index of the next map will be l + ind2
%

results.seqValues
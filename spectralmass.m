% Calculates spectral mass difference between two datasets (no gui version)
%
% Usage:
%   >>  p_value = pop_spectralmass( EEG1, EEG2, channel, R );
%
% Inputs:
%   EEG1,EEG2 - The two datasets that we are comparing
%   channel   - Channel number to analyse
%   R         - Number of randomisation samples (e.g. 1000)
%   filenames - Name of files (for plotting titles)
%    
% Outputs:
%   p_value  - probability that the two datasets contain the same amount of
%              "spectral mass"
%
% Author: Marco Filetti, Helsinki Institute for Information Technology
%         HIIT, 2014
%
% See also:
%   spectralmass 

% Copyright (C) 2014  Marco Filetti
%
% This program is free software; you can redistribute it and/or modify
% it under the terms of the GNU General Public License as published by
% the Free Software Foundation; either version 2 of the License, or
% (at your option) any later version.
%
% This program is distributed in the hope that it will be useful,
% but WITHOUT ANY WARRANTY; without even the implied warranty of
% MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
% GNU General Public License for more details.
%
% You should have received a copy of the GNU General Public License
% along with this program; if not, write to the Free Software
% Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA

function p_value = spectralmass(EEG1,EEG2,channel,R,filenames,startwin,endwin,lowfreq,highfreq,baseline)

figh = figure;

[randtrials1s, randtrials2s, samples, orderings] = sm_randomordermaker(size(EEG1.data,3),size(EEG2.data,3),R );

[ersp_obsval, ersp_nullHD, itc_obsval, itc_nullHD] = sm_getvals(EEG1,EEG2,channel,filenames,@sm_differencemeasure,R,figh,randtrials1s,randtrials2s,samples,orderings,startwin,endwin,lowfreq,highfreq,baseline);

%% get ersp p-value
ersp_p = sum(ersp_nullHD>=ersp_obsval)/R;
if ersp_p == 0
    ersp_p = 1/R;
end

%% get itc p-value
itc_p = sum(itc_nullHD>=itc_obsval)/R;
if itc_p == 0
    itc_p = 1/R;
end

%% Fisher
ersp_pvals = p_convert(ersp_nullHD);
itc_pvals = p_convert(itc_nullHD);

% combine p values into Wf distribution
fisher_dist = zeros(1,R);
for i = 1 : R
    fisher_dist(i) = -2*log(ersp_pvals(i)*itc_pvals(i));
end

% calculate fisher value for observed value
fisher_obs = -2*log(ersp_p*itc_p);

%get p value for fisher procedure
p_value = sum(fisher_dist>=fisher_obs)/R;

if p_value == 0
    p_value = 1/R;
end

end

function pvalD = p_convert(nullHD)
%convert nullhypothesis dist. to null hypothesis dist of p values
pvalD = nullHD;
for i = 1 : numel(nullHD)
    pvalD(i) = sum(nullHD>=pvalD(i))/numel(nullHD);
    % don't allow for 0, instead set to minimum possible (1/1000 if
    % using 1000 randomisation samples)
    if pvalD(i) == 0
        pvalD(i) = 1 / numel(nullHD);
    end
end
end

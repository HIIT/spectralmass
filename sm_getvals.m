function [ersp_diff, nullERSP, itc_diff, nullITC] = sm_getvals(EEG1,EEG2,chan,filenames,sm_function,R,figh,randtrials1s,randtrials2s,samples,orderings,startwin,endwin,lowfreq,highfreq,baseline)
% Performs spectral mass analysis
% sm_function: difference measure function used by SM

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

NOFOUTPUTS = 2; % SM outputs ERSP and ITC

parameters = struct();


parameters.winstart = startwin; % ms of start of window that will be used
parameters.winend = endwin; % (will be rounded to neared available t/f block since timefreq() has a limited number of timepoints output)
parameters.minfreq = lowfreq;
parameters.maxfreq = highfreq;
parameters.baseline = baseline; % seconds for baseline correction (if used, otherwise NaN)
parameters.winstart = startwin; % ms of start of window that will be used
parameters.winend = endwin; % (will be rounded to neared available t/f block since timefreq() has a limited number of timepoints output)
parameters.nfreqs = round(highfreq-lowfreq)*7; % Seven frequency points comprise 1 hertz (adapted from EEGLAB defaults)
parameters.ntimes = round(endwin-startwin)/4; % A timepoint gathers 4 milliseconds (adapted from EEGLAB defaults)
parameters.frames = EEG1.pnts;
parameters.xmin = EEG1.xmin;
parameters.xmax = EEG1.xmax;
parameters.srate = EEG1.srate;
parameters.filenames = filenames;
parameters.wantplot = 1;

%% calculate EEG1 - EEG2 observed difference
figh = sfigure(figh);
clf;

diffresult = sm_function(EEG1.data(chan,:,:),EEG2.data(chan,:,:),parameters);
ersp_diff = diffresult(1);
itc_diff = diffresult(2);


%% randomize null hyp. dist
parameters.wantplot = 0;
randout = sm_randomizer( EEG1.data(chan,:,:),EEG2.data(chan,:,:),sm_function,parameters,R,NOFOUTPUTS,randtrials1s,randtrials2s,samples,orderings);

nullERSP = randout(:,1);
nullITC = randout(:,2);



end


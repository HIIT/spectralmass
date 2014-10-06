% Spectral mass itc and ersp difference calculator
%
% Usage:
%   >>  result = sm_differencemeasure( first,second,parameters );
%
% Inputs:
%   first , seconds   - The two raw data EEGLAB matrices to compare
%   parameters    - parameters struct
%    
% Outputs:
%   result  - [ersp itc] differences
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

function result = sm_differencemeasure( first,second,parameters )

winstart = parameters.winstart; % ms of start of window that will be used
winend = parameters.winend; % (will be rounded to neared available t/f block since timefreq() has a limited number of timepoints output)
nfreqs = parameters.nfreqs; % number of frequencies outputted by newtimef
ntimes = parameters.ntimes; % number of timepoints outputted by timefreq window limitis above will need to be rounded according to this value
minfreq = parameters.minfreq;
maxfreq = parameters.maxfreq;
baseline = parameters.baseline; % [start end] ms for baseline correction (e.g. [-100 0])
frames = parameters.frames;
xmin = parameters.xmin;
xmax = parameters.xmax;
srate = parameters.srate;
filenames = parameters.filenames;
wantplot = parameters.wantplot;

if wantplot
    exception = 'Running';
    runs = 0;
    while ~isempty(exception)
        try
            [ersp,itc,~,times,~,~,~] = newtimef({first second},frames,[xmin xmax]*1000,srate,0,'baseline',baseline,...
                    'timesout',ntimes,'nfreqs',nfreqs,'plotphasesign','off','freqs',[minfreq maxfreq],'ydir','down','vert',[winstart winend],...
                    'title',{filenames{1} filenames{2} [filenames{1} '-' filenames{2}]},'newfig','off');
            exception = [];
        catch exception
            disp(exception);
            disp('Retrying...');
            runs = runs + 1;
            if runs == 5;
                disp('REPEATED ERROR WHILE PLOTTING. SKIPPING PLOT');
            [ersp,itc,~,times,~,~,~] = newtimef({first second},frames,[xmin xmax]*1000,srate,0,'baseline',baseline,...
                    'timesout',ntimes,'nfreqs',nfreqs,'freqs',[minfreq maxfreq],'plotitc','off','plotersp','off');
            end
        end
    end
else
    [~,ersp,itc,~,times,~,~,~] = evalc('newtimef({first second},frames,[xmin xmax]*1000,srate,0,''baseline'',baseline,''timesout'',ntimes,''nfreqs'',nfreqs,''freqs'',[minfreq maxfreq],''plotersp'',''off'',''plotitc'',''off'')');
end
    
ersp = ersp{3};
ersp = ersp(1:nfreqs,:);
itc = itc{3};
itc = itc(1:nfreqs,:);

for i=1:numel(times)
    if times(i) >= winstart
        tfstart = i;
        break
    end
end
for i=tfstart:numel(times)
    if times(i) > winend
        tfend = i - 1;
        break
    end
end

ersp = sm_tfdiffcalc( ersp,[tfstart tfend] );
itc = sm_tfdiffcalc( itc,[tfstart tfend] );

result = [ersp itc];

end


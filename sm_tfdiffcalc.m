function outval = sm_tfdiffcalc( input,window )
% Calculate a time frequency value (for an ERSP or ITC array difference
% coming from eeglab) based on the system requested
% usage
% input : array (freq x time) coming from EEGLAB newtimef function (esrp or itc) DIFFERENCE
% (3rd cell); must only contain frequencies of interest
% window: two scalars [windowstart windowend] they must be integers referring to
% the columns of the input argument. If not specified then cluster system
% is assumed (largest above threshold cluster - no diagonals).

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

    winstart = window(1);
    winend = window(2);
    input = input(:,winstart:winend);
    %% return summation
    outval = sum(input(input > 0)); % if output would be 0, change to a very small random number to avoid outputs with all zeros
    if outval == 0
        outval = randn/1000;
    end


end


% Spectral Mass EEGLAB plugin (version 0.1). See
% http://www.hiit.fi/marco.filetti/spectralmass for details.
%
% Usage:
%   To analyse two segmented datasets, click Tools > Spectral Mass menu.
%
% Author: Marco Filetti, Helsinki Institute for Information Technology
%         HIIT, 2014
%
% See also:
%   SPECTRALMASS 

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

function vers = eegplugin_spectralmass(fig, trystrs, catchstrs)

    vers = 'spectralmass0.1';
    if nargin < 3
        error('eegplugin_spectralmass requires 3 arguments');
    end
        
    % find tools menu
    % ---------------------
    toolsmenu = findobj(fig, 'tag', 'tools');
    
    % menu callbacks
    % --------------
    cmd = 'EEG = pop_spectralmass(ALLEEG);';
    finalcmd = [ trystrs.no_check cmd ];
    finalcmd = [finalcmd 'LASTCOM = ''' cmd ''';' ];
    
    mycallback = [finalcmd catchstrs.add_to_hist];
    
    % add new submenu
    uimenu( toolsmenu, 'label', 'Spectral Mass', 'callback', mycallback, 'userdata', 'continuous:off');
    
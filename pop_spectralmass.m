% Calculates spectral mass difference between two datasets (gui version)
%
% Usage:
%   >>  p_value = pop_spectralmass( ALLEEG, idnos );
%
% Inputs:
%   ALLEEG   - Structure containing all EEG datasets in memory (must be at
%              least 2 otherwise returns an error)
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

function [p_value, com] = pop_spectralmass( ALLEEG )

% the command output is a hidden output that does not have to
% be described in the header

com = ''; % this initialization ensure that the function will return something
          % if the user press the cancel button            

% display help if not enough arguments
% ------------------------------------
if nargin < 1
	help pop_spectralmass;
	return;
end;	

if numel(ALLEEG) < 2
    error('At least two datasets should be loaded in EEGLAB before calculating their spectral mass difference, so that they can be compared.');
end
%% prepare choice list
secondlist = '';

% format of names displayed in dialog:
% dataset_filename (dataset_name - if any)

% put fist dataset in first choice of first list
if numel(ALLEEG(1).setname > 0)
    appendname = [' (' ALLEEG(1).setname ')'];
else
    appendname = '';
end
firstlist = [ALLEEG(1).filename appendname];
for i = 2 : numel(ALLEEG)
    if numel(ALLEEG(i).setname > 0)
        appendname = [' (' ALLEEG(i).setname ')'];
    else
        appendname = '';
    end
    firstlist = [firstlist '|' ALLEEG(i).filename appendname];
    if isempty(secondlist)
        secondlist = [ALLEEG(i).filename appendname];
    else
        secondlist = [secondlist '|' ALLEEG(i).filename appendname];
    end
end
% put first dataset in last choice of second list
if numel(ALLEEG(1).setname > 0)
    appendname = [' (' ALLEEG(1).setname ')'];
else
    appendname = '';
end
secondlist = [secondlist '|' ALLEEG(1).filename appendname];

%% prepare channel list (note: datasets are assumed to have the same channel identifiers)
chanlist = ALLEEG(1).chanlocs(1).labels;
for i = 2 : numel(ALLEEG(1).chanlocs)
    chanlist = [chanlist '|' ALLEEG(1).chanlocs(i).labels];
end
for i = 2 : numel(ALLEEG)
    for j = 1 : numel(ALLEEG(1).chanlocs)
        if ~strcmpi(ALLEEG(1).chanlocs(j).labels,ALLEEG(i).chanlocs(j).labels)
            error('Channel numbers and labels are not the same across datasets (they are assumed to be by this function).');
        end
    end
end

%% display dialog
[res, userdata, err, structout] = inputgui( 'geometry', { [1 2] [1 2] 1 [1 4] [3 1] [3 1] [3 1] [3 1] [3 1] [3 1]}, ...
     'geomvert', [3 3 1 3 1 1 1 1 1 1], 'uilist', { ...
     { 'style', 'text', 'string', [ 'First dataset' 10 10 10 ] }, ...
     { 'style', 'listbox', 'string', firstlist 'tag' 'firstset' }, ...
     { 'style', 'text', 'string', [ 'Second dataset' 10 10 10 ] }, ...
     { 'style', 'listbox', 'string', secondlist 'tag' 'secondset' }, ...
     { 'style', 'text', 'string', 'Spectral mass will be calculated on the first dataset minus second dataset difference'}, ...
     { 'style', 'text', 'string', [ 'Channel' 10 10 10]}, ...
     { 'style', 'listbox', 'string', chanlist 'tag' 'channel' },...
     { 'style', 'text', 'string', 'Number of randomisation samples'}, ...
     { 'style', 'edit', 'string', '1000' 'tag' 'R' }, ...
     { 'style', 'text', 'string', 'Start of spectral mass window (ms)'}, ...
     { 'style', 'edit', 'string', '150' 'tag' 'startwin' }, ...
     { 'style', 'text', 'string', 'End of spectral mass window (ms)'}, ...
     { 'style', 'edit', 'string', '1000' 'tag' 'endwin' }, ...
     { 'style', 'text', 'string', 'Lower frequency boundary (Hz)'}, ...
     { 'style', 'edit', 'string', '0.5' 'tag' 'lowfreq' }, ...
     { 'style', 'text', 'string', 'Higher frequency boundary (Hz)'}, ...
     { 'style', 'edit', 'string', '8' 'tag' 'highfreq' }, ...
     { 'style', 'text', 'string', 'Baseline (seconds)'}, ...
     { 'style', 'edit', 'string', '[-100 0]' 'tag' 'baseline' } } );
 if isempty(res) % user closed / cancelled operation
     p_value = [];
     return
 end

%% check and filter outputs
id1 = structout.firstset;
id2 = structout.secondset + 1;
channel = structout.channel;
R = str2num(structout.R);
startwin = str2num(structout.startwin);
endwin = str2num(structout.endwin);
lowfreq = str2num(structout.lowfreq);
highfreq = str2num(structout.highfreq);
baseline = str2num(structout.baseline);
        
% last choice of second list was the first dataset, correct for this
if id2 > numel(ALLEEG)
    id2 = 1;
end

% check if we are comparing the same dataset
    
EEG1 = ALLEEG(id1);
EEG2 = ALLEEG(id2);

if all(size(EEG1.data) == size(EEG2.data))
    if all(all(all(EEG1.data == EEG2.data)))
        error('Two identical datasets are being compared')
    end
end

%% call function on selected dataset
p_value = spectralmass( EEG1, EEG2, channel, R, {EEG1.filename EEG2.filename}, startwin, endwin, lowfreq, highfreq, baseline );

idnos = [id1 id2];

%% return the string command
com = sprintf('pop_spectralmass( ALLEEG, [%s] );', int2str(idnos));

%% show final p-value
disp(sprintf(['Spectral Mass p-value (difference between ' EEG1.filename ' and ' EEG2.filename '): %.' num2str(numel(num2str(R))-1) 'f'],p_value));

return;

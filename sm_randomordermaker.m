function [randtrials1s, randtrials2s, samples, orderings] = sm_randomordermaker( firstsize,secondsize,R )
% Generate two lists of index order to be selected later in the
% randomisation
% structure of outputs:
% rows : R (randomisation index)
% columns : trial ordering

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

samples = min(firstsize,secondsize);

randtrials1s = zeros(R,samples);
randtrials2s = zeros(R,samples);
orderings = zeros(R,samples*2);

for j = 1 : R
    randtrials1 = randNoRep(1:firstsize,samples);
    randtrials2 = randNoRep(1:secondsize,samples);
    
    randtrials1s(j,:) = randtrials1;
    randtrials2s(j,:) = randtrials2;
    
    orderings(j,:) = randNoRep(1:samples*2,samples*2);
end

end


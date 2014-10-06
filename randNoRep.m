function [randValues, remainingVals] = randNoRep( input, nOfValues )
% Get a random set of values (of size nOfValues) taken from input, with no replacement
% so that every value can appear only once. If input is a matrix, then it
% must be a vertical concatenation of row vectors.
% Returns:
% randValues: randomly selected values with no replacement from input. It
% is a vertical concatenation of row vectors (or just a vertical vector)
% remainingVals: the values which were not taken randomly and placed in
% randValues will be returned here.
% if input is only a row vector, turn into vertical (column) vector

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

if size(input,1) == 1
    input = rot90(rot90(rot90(input)));
end

randValues = zeros(nOfValues,size(input,2));

if size(input,1) < nOfValues
    error('LABMAT:randNoRep:nOfValues','nOfValues must be >= n of rows of input');
end

for i=1:nOfValues
    randIndex = ceil(rand*size(input,1));
    randValues(i,:) = input(randIndex,:);
    if randIndex == 1
        input = input(2:size(input,1),:);
    elseif randIndex == size(input,1)
        input = input(1:randIndex-1,:);
    else
        input = vertcat(input(1:randIndex-1,:),input(randIndex+1:size(input,1),:));
    end
end

remainingVals = input;

end


function outputs = sm_randomizer( first,second,func,parameters,R,outputsize,randtrials1s,randtrials2s,samples,orderings )
% Perform randomisation to estimate out the null hypotesis distribution
% inputs
% first & second : first and second conditions
% func : function handle of difference measure
% parameters : parameters used by difference measure
% R : number of randomization samples

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

outputs = zeros(R,outputsize);

frames = parameters.frames;

waitbarH = waitbar(0,'Generating randomised distribution...');

for j = 1 : R
    randtrials1 = randtrials1s(j,:);
    randtrials2 = randtrials2s(j,:);
    
    trialpool = zeros(1,frames,samples*2); % pool containing all trials for both conditions
    
    trialpool(1,:,1:samples) = first(1,:,randtrials1);
    trialpool(1,:,samples+1:samples*2) = second(1,:,randtrials2);
    
    neword = orderings(j,:);

    trialpool(1,:,:) = trialpool(1,:,neword);
    
    % split into two separate trial pools and compute differences
    pool1 = trialpool(1,:,1:samples);
    pool2 = trialpool(1,:,samples+1:samples*2);
    
    outputs(j,:) = func(pool1,pool2,parameters);
    
    waitbar(j/R);
end
close(waitbarH);

end


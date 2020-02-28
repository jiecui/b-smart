function data = pre_sube(dat)
% PRE_SUBE Subtract the ensemble mean
% 
% Usage:
%  data = pre_sube(dat);
% 
%  dat: input data in MAT format = samples x channels x trials
%  data: output file after subtract the ensemble mean

% Copyright (c) 2006-2007 BSMART group.
% by Richard Cui
% $Revision: 0.3$ $Date: Fri 02/28/2020  4:47:19.718 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

[num_chan, num_trl] = size(dat, [2, 3]);
for i = 1:num_chan
    b_i = dat(:,i,:);
    c_i = mean(b_i,3);      % channel ensemble mean
    for j = 1:num_trl
        dat(:,i,j) = dat(:,i,j)-c_i;  % subtract esnemble mean
    end
end
data = dat;

end%pre_sube

% [EOF]

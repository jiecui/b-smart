function [Fx2y,Fy2x, Tx2y, Ty2x]= one_bi_ga(dat,startp,window,order,fs,freq)
% ONE_BI_GA Compute the granger causality from the one window Bivariate models
% 
% Usage:
%   [Fx2y,Fy2x]= one_bi_ga(dat,startp,window,order,fs,freq) 
% 
% Input(s):
%   dat     - data set in Matlab format
%   starp   - start position
%   window  - window length
%   order   - model order
%   fs      - Sampling rate
%   freq    - a vector of frequencies of interest, usually freq=0:fs/2
% 
% Output(s):
%   Fx2y    - The Granger causality measure from x to y in frequency domain
%   Fy2x    - The Granger causality from y to x in frequency domain
%             The order of Fx2y/Fy2x is 1 to 2:L, 2 to 3:L,....,L-1 to L, where
%             L is the number of channels. That is, 1st column: 1&2; 2nd:
%             1&3; ...; (L-1)th: 1&L; ...; (L(L-1))th:(L-1)&L.
%   Tx2y    - The Granger causality measure from x to y in time domain
%   Ty2x    - The Granger causality measure from y to x in time domain
% 
% Example:
%   [Fx2y,Fy2x]= one_mul_ga(data,1,10,5,200,[1:100])
% 
% See also: mov_bi_ga.

% Copyright (c) 2006-2020 BSMART group.
% by Richard Cui
% $Revision: 0.4$ $Date: Mon 03/02/2020 10:30:45.153 PM$
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

trail    = size(dat,3);
channel2 = size(dat,2);
points   = window;
a        = zeros(2,trail*points);

dat = dat(startp:startp+window-1,:,:);
Fxy = [];
Fyx = [];
for i = 1:(channel2-1)
    for j = (i+1):channel2
        for k = 1:trail
            a(1,(k-1)*points+1:k*points) = dat(:,i,k);
            a(2,(k-1)*points+1:k*points) = dat(:,j,k);
        end
        [~, ~, Fx2y, Fy2x] = pwcausal(a,trail,points,order,fs,freq);
        Fxy = cat(1,Fxy,Fx2y);
        Fyx = cat(1,Fyx,Fy2x);
    end
end

% frequency domain
% ----------------
Fx2y = Fxy;
Fy2x = Fyx;

% time domain
% -----------
Tx2y = mean(Fx2y, 2);
Ty2x = mean(Fy2x, 2);

end%one_bi_ga

% [EOF]

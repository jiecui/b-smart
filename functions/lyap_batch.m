function LE = lyap_batch(arcoeff,arnoise,T)
% LYAP_BATCH A batch version to compute Lyapunov exponen
% 
% Usage: 
%   LE = lyap_batch(arcoeff,arnoise,T);
% 
%   arcoeff         - model coefficients
%   arnoise         - noise coefficients
%   T   -   Number of samples to generate
% 
%   LE              - Lyponov exponent ( < 0 not stable)
% 
% Note: 
%   In fact we do not use ARNOISE in Lyapunov calculation, 
%   but need it in MAR_make routine
%
% See also .

% Copyright (c) 2006-2020 BSMART group.
% by Richard Cui
% $Revision: 0.3$ $Date: Sat 02/29/2020  2:50:39.405 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

LE = [];
len = size(arnoise,1);
fw = waitbar(0,'Please wait...', 'Name', 'Lyapnov Exponent');
for t = 1:len
    waitbar(t/len, fw);
    mar = MAR_make(arcoeff(t,:), arnoise(t,:));
    le = lyap(mar,T,1000);          % LE = lyap(mar, T, discardnum);
    LE = cat(2,LE,le);
end
delete(fw);

end%lyap_batch

% [EOF]
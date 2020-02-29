function [resid, winidx] = whitenesstest(dat, windowlen, order, varargin)
% WHITENESSTEST test the whniteness of residue at given windows
% 
% Syntax:
%   [resid, winidx] = whitenesstest(dat, windowlen, order)
%   __ = __(__, startp)
%   __ = __(__, startp, endp)
% 
% Input(s):
%   dat             - [array] dataset (sample x channel x trial)
%   windowlen       - [num] window length (samples)
%   order           - [num] model order
%   startp          - [num] (opt) start position of the 1st window (sample)
%                     (default = 1)
%   endp            - [num] last position of the last window (sample)
%                     (default = signal length)
% 
% Output(s):
%   resid           - [num] probability of whiteness of residue
%   winidx          - [num] index of the windows where whitness test is done
% 
% See also .

% Copyright (c) 2020 Richard J. Cui. Created: Sat 02/29/2020  9:38:41.372 AM
% $Revision: 0.1$ $Date: Sat 02/29/2020  9:38:41.372 AM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% =========================================================================
% parse inputs
% =========================================================================
q = parseInputs(dat, windowlen, order, varargin{:});
dat = q.dat;
windowlen = q.windowlen;
order = q.order;

sig_len = size(dat, 1); % signal length
startp = q.startp;
if isempty(startp)
    startp = 1;
end % if
endp = q.endp;
if isempty(endp)
    endp = sig_len;
end % if

% =========================================================================
% parse inputs
% =========================================================================
% get whitness of all windows
% ---------------------------
resid_all = whiteness_test(dat, windowlen, order);

% output whitenss test of selected windows
% ----------------------------------------
first_last_p = endp-windowlen+1; % first position of the last window
winidx = startp:first_last_p;
resid = resid_all(winidx);

end

% =========================================================================
% subroutines
% =========================================================================
function q = parseInputs(varargin)

% defaults
default_sp = [];
default_ep = [];
    
% parse rules
p = inputParser;
p.addRequired('dat', @isnumeric);
p.addRequired('windowlen', @isnumeric);
p.addRequired('order', @isnumeric);
p.addOptional('startp', default_sp, @isnumeric);
p.addOptional('endp', default_ep, @isnumeric);

% parse and return results
p.parse(varargin{:});
q = p.Results;

end % function

% [EOF]
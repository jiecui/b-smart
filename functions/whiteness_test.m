function [resid] = whiteness_test(dat,window,order)
% WHITENESS_TEST Whiteness test
%
%   dat: data set in Matlab format
%   window: window length
%   order: model order
%
%   resid: residuals probabilities
%
% Example:
%   [resid] = whiteness_test(data,10,5)

% Copyright (c) 2006-2007 BSMART group.
% by Richard Cui
% $Revision: 0.3$ $Date: Sat 02/29/2020  9:38:41.372 AM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% parse directory
cdir = pwd;                 % find current directory
p = mfilename('fullpath');
fdir = fileparts(p);        % find function directory
cd(fdir);                   % change current dir to function dir

[points, channel, trail] = size(dat);
save channel channel -ascii;
save trail trail -ascii;
save points points -ascii;
save window window -ascii;
save order order -ascii;

writedat('dataset.bin',dat);
opsswhite_fun = fullfile(fdir, 'opsswhite');
opsswhite_com = sprintf('%s dataset.bin A Ve', opsswhite_fun);
% if ispc
%     status = eval(['unix ' '(''' 'opsswhite ' 'dataset.bin ' ' A ' 'Ve' ''')']);
% else
%     status = eval(['unix ' '(''' './opsswhite ' 'dataset.bin ' ' A ' 'Ve' ''')']);
% end%if
status = unix(opsswhite_com);

% clean job one
delete channel
delete trail
delete points
delete window
delete order
delete dataset.bin
% if error
if status ~= 0
    error('Cannot test whiteness with ''opsswhite''!');
end%if
% otherwise
resid = load('resid.out');
% clean job two
delete resid.out
delete A
delete Ve

% restore directory
cd(cdir);

end%whiteness_test

% [EOF]
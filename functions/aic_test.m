function AIC = aic_test(dat,winlen,maxorder)
% AIC_TEST Compute the AIC
% 
%   dat: data set in Matlab format
%   winlen: window length
%   maxorder: the maximum model order you want to try.
%   AIC: each row is the AIC coefficient for each window.
% 
% Example:
%   [AIC] = aic_test(data,10,8)

% Copyright (c) 2006-2020 BSMART group.
% by Richard Cui
% $Revision: 0.4$ $Date: Thu 02/27/2020  7:37:53.649 PM$
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

% save opssaic input arguments
[pts, chan, trl] = size(dat);
save channel chan -ascii;
save trail trl -ascii;
save points pts -ascii;
save window winlen -ascii;
save order maxorder -ascii;
writedat('dataset.bin',dat);

% TODO: implement with MEX utility
opssaic_fun = fullfile(fdir, 'opssaic');
opssaic_com = sprintf('%s dataset.bin A Ve AIC_now', opssaic_fun);
% if ispc
%     status = eval(['unix' '(''' 'opssaic ' 'dataset.bin ' ' A ' 'Ve ' 'AIC_now' ''')']);
% else
%     status = eval(['unix' '(''' './opssaic ' 'dataset.bin ' ' A ' 'Ve ' 'AIC_now' ''')']);
% end%if
status = unix(opssaic_com);

% clean job one
delete channel
delete trail
delete points
delete window
delete order
delete dataset.bin
% if error
if status ~= 0
    error('Cannot compute AIC with ''opssaic''!');
end%if
% otherwise
% TODO: matlab version compatible
AIC = load('AIC_now');
% clean job two
delete AIC_now
delete A
delete Ve

% restore directory
cd(cdir);

end%aic_test

% [EOF]
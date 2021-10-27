function [A,Ve] = mov_mul_model(dat,order,startp,endp,window)
% MOV_MUL_MODEL Moving window for multivariate model
%
% Usage:
%   mov_one_mul(dat, order, startp, endp, window);
% 
%   dat: input file in matlab format;
%   order: model order
%   startp: start position
%   endp: ending position
%   window: window length
% 
% Output:  
%   A is the name of AR coefficient file
%	Ve is the name of AR noise file

% Copyright (c) 2006-2007 BSMART group.
% by Richard Cui
% $Revision: 0.3$ $Date: Thu 02/27/2020  8:15:18.339 PM$
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

% processing
si=size(dat);
% npoints=si(1);
ntrails=si(3);
nchannels=si(2);
start=startp;

channel=nchannels;
save channel channel -ascii;

trail=ntrails;
save trail trail -ascii;

points=endp-start+1;
save points points -ascii;

% window=window;
save window window -ascii;

% order=order;
save order order -ascii;
dat=dat(start:endp,:,:);
writedat('dataset.bin',dat);

opssmov_fun = fullfile(fdir, 'opssmov');
opssmov_com = sprintf('%s dataset.bin A Ve', opssmov_fun);

% if ispc
%     eval(['unix ' '(''' 'opssmov ' 'dataset.bin ' ' A ' 'Ve' ''')']);
% else
%     eval(['unix ' '(''' './opssmov ' 'dataset.bin ' ' A ' 'Ve' ''')']);
% end%if
status = unix(opssmov_com);
if status ~= 0
    error('Cannot comput with ''opssmov!''')
end % if
A=load('A');
Ve=load('Ve');

delete A
delete Ve
delete channel
delete trail
delete points
delete window
delete order
delete dataset.bin

% restore directory
cd(cdir);

end%mov_mul_model

% [EOF]
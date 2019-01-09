function [A,Ve] = one_mul_model(dat,order,startp,window)
% ONE_MUL_MODEL One window for multivariate model
% 
% Usage:
%   [A,Ve] = mov_mul_model (dat,order,startp,window);
% 
% Input(s):
%   dat: input file in matlab format;
%   order: model order
%   startp: start position of the window
%   window: window length
% 
% Output(s):
%   A   -   AR coefficient file
%	Ve  -   AR noise file 
% 
% Reference:
%   Cui, J., Xu, L., Bressler, S. L., Ding, M., & Liang, H. (2008). BSMART:
%   A MATLAB/C toolbox for analysis of multichannel neural time series.
%   Neural Networks, 21(8), 1094-1104. doi: DOI 10.1016/j.neunet.2008.05.007


% Copyright 2007-2015 Richard J. Cui. Created: 11-Sep-2007 22:58:31
% $Revision: 0.2 $  $Date: Tue 02/10/2015  8:50:06.470 AM $
%
% Sensorimotor Research Group
% School of Biological and Health System Engineering
% Arizona State University
% Tempe, AZ 25287, USA
%
% Email: richard.jie.cui@gmail.com

% parse directory
cdir = pwd;                 % find current directory
p = mfilename('fullpath');
fdir = fileparts(p);        % find function directory
cd(fdir);                   % change current dir to function dir

% processing
channel = size(dat,2);
trail = size(dat,3);
save channel channel -ascii;
save trail trail -ascii;
save points window -ascii;
save order order -ascii;

start = startp;
dat = dat(start:start+window-1,:,:);
writedat('dataset.bin',dat);

if ispc
    eval(['unix ' '(''' 'opssfull ' 'dataset.bin ' ' A ' 'Ve ' 'AIC' ''')'])
elseif ismac
    unix ('./opssfull dataset.bin  A Ve AIC');
else
    eval(['unix ' '(''' './opssfull ' 'dataset.bin ' ' A ' 'Ve ' 'AIC' ''')']);
end%if
A = load('A');
Ve = load('Ve');

delete A
delete Ve
delete channel
delete trail
delete points
delete AIC
delete order
delete dataset.bin

% restore directory
cd(cdir);

end % one_mul_model

% [EOF]
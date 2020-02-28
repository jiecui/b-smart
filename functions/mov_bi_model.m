function mov_bi_model(dat,order,startp,endp,window)
% MOV_BI_MODEL Moving window for bivariate models
%
% Usage:
%   mov_bi_model(dat,order,startp,endp,window);
%
% Input(s):
%   dat     -   input file in matlab format;
%   order   -   model order
%   startp  -   start position
%   endp    -   ending position
%   window  -   window length
%
% Output(s):
%   in the bsmartroot/Movingwindow_Coefficient directory

% Copyright (c) 2006-2020 BSMART Group
% by Richard Cui
% $Revision: 0.3$ $Date: Thu 02/27/2020  8:15:18.339 PM$
% SHIS UT-Houston, Houston, TX 77030, USA.
% 
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

cd('..')
mv_dir = pwd; % get the dir of 'Movingwindow_Coefficient' folder
cd(fdir);

% processing

% si =size(dat);
% start=startp;
% ntrails = si(3);
% nchannels=si(2);
% trail=ntrails;
% window=window;
% order=order;

channel2 = size(dat,2);
trail = size(dat,3);
channel = 2;
points = endp-startp+1;
save channel channel -ascii;
save trail trail -ascii;
save points points -ascii;
save window window -ascii;
save order order -ascii;

PathName=fullfile(mv_dir, 'Movingwindow_Coefficient');
% str=['!DEL /Q ' PathName '\*'];
% eval(str);
coefile = [PathName,'\*'];
delete(coefile);            % delete all coefficients files in the directory

dat=dat(startp:endp,:,:);
opssmov_fun = fullfile(fdir, 'opssmov');
opssmov_com = sprintf('%s dataset.bin A Ve', opssmov_fun);
fw = waitbar(0, 'Creating model...');
for i=1:(channel2-1)
    waitbar(i/(channel2-1), fw)
    for j=(i+1):channel2
        dat1=dat(:,i,:);
        dat2=dat(:,j,:);
        dat3=cat(2,dat1,dat2);
        writedat('dataset.bin',dat3);
        % if ispc
        %     eval(['unix ' '(''' 'opssmov ' 'dataset.bin ' ' A ' 'Ve' ''')']);
        % else
        %     eval(['unix ' '(''' './opssmov ' 'dataset.bin ' ' A ' 'Ve' ''')']);
        % end%if
        status = unix(opssmov_com);
        if status ~= 0
            error('Cannot compute with ''opssmov''!')
        end % if
        
        ii=num2str(i);jj=num2str(j);
        FileName=['AR_C_' ii 'and' jj];
        fA=fullfile(PathName,FileName);
        % eval(['!MOVE ' 'A ' fA ]);
        movefile('A',fA);
        FileName2=['AR_N_' ii 'and' jj];
        fVe=fullfile(PathName,FileName2);
        % eval(['!MOVE ' 'Ve ' fVe ]);
        movefile('Ve',fVe);

        % !DEL dataset.bin
        delete dataset.bin
    end
end
delete(fw)

% !DEL channel
% !DEL trail
% !DEL points
% !DEL order
% !DEL window
delete channel
delete trail
delete points
delete order
delete window

helpdlg('All model coefficient save in Movingwindow_Coefficient directory','Completed');

% restore directory
cd(cdir);

end%mov_bi_model

% [EOF]

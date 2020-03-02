function varargout = ga_view(Fxy,Fyx,fs,chx,chy,timen)
%  GA_VIEW View Granger causality
%
% Syntax:
%   ga_view(Fxy, Fyx, fs, chx, chy)
%   ga_view(__, timen)
%   [time, freq, gc_spectrogram] = ga_view(__)
%   [time, gc_spectrum] = ga_view(__)
% 
% Input(s):
%   Fxy, Fyx    - granger causality data set
%   fs          - sampling rate
%   chx         - one channel
%   chy         - another channnel
%   timen       - (optional): view coherence at one time
%
% Note:
%   If no output, ga_view shows the figures. Otherwise, send out the
%   parameters of GC spectrogram and GC spectrum.
% 
%  Example:
%   ga_view(Fxy,Fyx,200,9,10);
%   ga_view(Fxy,Fyx,200,10,9,5);
%
% See also: one_bi_ga, mov_bi_ga.

% Copyright (c) 2006-2020 BSMART group.
% by Richard Cui
% $Revision: 0.5$ $Date: Sun 03/01/2020  7:22:01.509 PM$
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

if nargin < 6
    % timen=0;
    dat  = Fxy;
    dat2 = Fyx;
    si   = size(dat);
    c = si(1);
    channel = (1+sqrt(1+8*c))/2;
    
    % % TODO: donot use symbolic toolbox
    % c    = si(1)*2;
    % s    = sprintf('x^2-x-%d',c);
    % dd   = solve(s);
    % dd   = double(dd);
    % if dd(1)>0
    %     channel=dd(1);
    % else
    %     channel=dd(2);
    % end
    
    
    i = chx;
    j = chy;
    if i < j
        ii = i;k = 0;
        m = channel-1;
        while i > 1
            k = k+m;
            m = m-1;
            i = i-1;
        end
        k = k+j-ii;
        if length(si) == 3
            c = dat(k,:,:); % Fxy
            c = squeeze(c);
            time = [1,si(3)];
            freq = [0,fs/2];
            if nargout == 0
                figure;
                imagesc(time,freq,c);
                axis xy;
                colorbar;
                tstr = sprintf('Granger Causality: Channel %d \\rightarrow Channel %d',chx,chy);
                title(tstr);
                xlabel('Time')
                ylabel('Frequency (Hz)');
            end % if
            if nargout > 0
                varargout{1} = time;
            end % if
            if nargout > 1
                varargout{2} = freq;
            end % if
            if nargout > 2
                varargout{3} = c;
            end % if
        else % draw GC spectrum
            c = dat(k,:);
            c = c';
            nb = si(2); % number of frequency bin
            frq = linspace(0,fs/2,nb);
            if nargout == 0
                figure;
                plot(frq,c);
                % axis([0,si(2),0,1]);
                h = gca;
                tstr = sprintf('Channel %d \\rightarrow Channel %d',chx,chy);
                title(h,tstr);
                xlabel(h,'Frequency (Hz)')
                ylabel(h,'Granger Causality')
            end % if
            if nargout > 0
                varargout{1} = frq;
            end % if
            if nargout > 1
                varargout{2} = c;
            end % if
        end
    else
        t=j;
        j=i;
        i=t;
        ii=i;k=0;
        m=channel-1;
        while i>1
            k=k+m;
            m=m-1;
            i=i-1;
        end
        k=k+j-ii;
        if length(si)==3
            c=dat2(k,:,:);  % Fyx
            c=squeeze(c);
            time = [1,si(3)];
            freq = [0,fs/2];
            if nargout == 0
                figure;
                imagesc(time,freq,c);
                axis xy;
                colorbar;
                tstr = sprintf('Granger Causality: Channel %d \\rightarrow Channel %d',chx,chy);
                title(tstr);
                xlabel('Time')
                ylabel('Frequency (Hz)');
            end % if
            if nargout > 0
                varargout{1} = time;
            end % if
            if nargout > 1
                varargout{2} = freq;
            end % if
            if nargout > 2
                varargout{3} = c;
            end % if
        else
            c=dat2(k,:);
            c=c';
            nb = si(2); % number of frequency bin
            frq = linspace(0,fs/2,nb);
            if nargout == 0
                figure;
                plot(frq,c);
                % axis([0,si(2),0,1]);
                h = gca;
                tstr = sprintf('Granger causality: Channel %d \\rightarrow Channel %d',chx,chy);
                title(tstr);
                xlabel(h,'Frequency (Hz)')
                ylabel(h,'Granger Causality')
            end % if
            if nargout > 0
                varargout{1} = frq;
            end % if
            if nargout > 1
                varargout{2} = c;
            end % if
        end
    end
else
    dat = Fxy;
    dat2 = Fyx;
    si = size(dat);
    c = si(1);
    channel = (1+sqrt(1+8*c))/2;
    
    % c  = si(1)*2;
    % s  = sprintf('x^2-x-%d',c);
    % dd = solve(s);
    % dd = double(dd);
    % if dd(1) > 0
    %     channel = dd(1);
    % else
    %     channel = dd(2);
    % end
    
    i = chx;
    j = chy;
    if i < j
        ii = i;k = 0;
        m = channel-1;
        while i > 1
            k = k+m;
            m = m-1;
            i = i-1;
        end
        k = k+j-ii;
        if length(si) == 3
            c = dat(k,:,timen); % Fxy
        else
            if timen > 1
                errordlg('please input correct time','parameter lost'); return;
            else
                c = dat(k,:);   % Fxy
            end
        end
        % figure('Name','Granger Causality','NumberTitle','off')
        nb = si(2); % number of frequency bin
        frq = linspace(0,fs/2,nb);
        if nargout == 0
            figure;
            plot(frq,c);
            % axis([0,si(2),0,1]);
            h = gca;
            tstr = sprintf('Channel %d \\rightarrow Channel %d',chx,chy);
            title(tstr);
            xlabel(h,'Frequency (Hz)')
            ylabel(h,'Granger Causality')
        end % if
        if nargout > 0
            varargout{1} = frq;
        end % if
        if nargout > 1
            varargout{2} = c;
        end % if
    else
        t=j;
        j=i;
        i=t;
        ii=i;k=0;
        m=channel-1;
        while i>1
            k=k+m;
            m=m-1;
            i=i-1;
        end
        k=k+j-ii;
        if length(si)==3
            c = dat2(k,:,timen);    % Fyx
        else
            if timen > 1
                errordlg('please input correct time','parameter lost'); return;
            else
                c = dat2(k,:);      % Fyx
            end
        end
        nb = si(2); % number of frequency bin
        frq = linspace(0,fs/2,nb);
        if nargout == 0 
            figure;
            plot(frq,c);
            % axis([0,si(2),0,1]);
            h = gca;
            tstr = sprintf('Channel %d \\rightarrow Channel %d',chx,chy);
            title(tstr);
            xlabel(h,'Frequency (Hz)')
            ylabel(h,'Granger Causality')
        end % if
        if nargout > 1
            varargout{1} = frq;
        end % if
        if nargout > 2
            varargout{2} = c;
        end % if
    end
end

end%function

% [EOF]
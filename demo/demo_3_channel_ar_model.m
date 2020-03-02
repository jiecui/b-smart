% TEST_3_CHANNEL_AR_MODEL test a simulated model using BSMART toolbox
% 
% Syntax:
%   test_3_channel_ar_model
% 
% Reference:
%       Ding, M. Z., Bressler, S. L., Yang, W. M., & Liang, H. L. (2000).
%   Short-window spectral analysis of cortical event-related potentials by
%   adaptive multivariate autoregressive modeling: data preprocessing,
%   model validation, and variability assessment. Biological Cybernetics,
%   83(1), 35-45.
% 
% See also .

% Copyright 2020 Richard J. Cui. Created: Sun 03/01/2020  7:22:01.509 PM
% $Revision: 0,1 $  $Date: Sun 03/01/2020  7:22:01.509 PM $
%
% 1026 Rocky Creek Dr NE
% Rochester, MN 55906, USA
%
% Email: richard.cui@utoronto.ca

% =========================================================================
% main
% =========================================================================
%% create the model
sig_len = 10; % signal length (points)
num_ch = 3;
num_trl = 100;
dat = zeros(sig_len, num_ch, num_trl);

lambda = .5;
sigma_x = 1;
sigma_y = .2;
sigma_z = .3;
for k = 1:num_trl
    [x, y, z] = constructModel(sig_len, lambda, sigma_x, sigma_y, sigma_z);
    dat(:, :, k) = [x, y, z];
end % for

%% estimate model
% preprocessing
% -------------
dat_pre = dat;
% dat_pre = pre_sube_divs(dat_pre);

% estimate model order using AIC test
% -----------------------------------
max_order = 8; % maxium model order to test
AIC = aic_test(dat_pre, sig_len, max_order);

% plot the result
figure
plot(AIC', '-o')
xlabel('Model order')
ylabel('AIC')
title('AIC Test')

% estimate the model
% ------------------
model_ord = 3;
startp = 1;
[A, Ve] = one_mul_model(dat_pre, model_ord, startp, sig_len);

%% calculate pairwise coherence
% theoretical coherence
c_xy = sigma_x^2/(sigma_x^2+sigma_y^2);
c_xz = sigma_x/(sigma_x^2+sigma_z^2);
c_yz = sigma_x^4/(sigma_x^2+sigma_y^2)/(sigma_x^2+sigma_z^2);

% estimate the coherence
fs = 200; % sampling frequency (Hz)
nfb = 100; % number of frequency bins
fx = linspace(0, nfb, nfb);
coh = paircoherence(A, Ve, nfb, fs);
C = squeeze(coh); % just one window

% plot the result
figure
plot(fx, C, 'LineWidth', 2)
hold on
plot(xlim, ones(2,1)*[c_xy, c_xz, c_yz], '--', 'LineWidth', 1)
ylim([.5 1])
legend('c_{xy}', 'c_{xz}', 'c_{yz}')
title('Paired Coherence')
xlabel('Frequency (Hz)')
ylabel('Coherence')

%% calculate pairwise Granger causality
% estimate the GC
% ---------------
fre_int = 0:fs/2; % frequencies of interest
[Fx2y, Fy2x] = one_bi_ga(dat_pre, startp, sig_len, model_ord, fs, fre_int);

% plot GC bwtween specified channel pair
% ---------------------------------------
chx = 1;
chy = 2;
chz = 3;
% chx <--> chy
[freq, s_xy] = ga_view(Fx2y, Fy2x, fs, chx, chy);
[~, s_yx] = ga_view(Fx2y, Fy2x, fs, chy, chx);
figure
plot(freq, s_xy, freq, s_yx, 'LineWidth', 2)
ylim([0, 4])
legend('x \rightarrow y', 'y \rightarrow x')
title('Granger causality between channel x and channel y')
xlabel('Frequency (Hz)')
ylabel('Granger causality')

% chx <--> chz
[freq, s_xz] = ga_view(Fx2y, Fy2x, fs, chx, chz);
[~, s_zx] = ga_view(Fx2y, Fy2x, fs, chz, chx);
figure
plot(freq, s_xz, freq, s_zx, 'LineWidth', 2)
ylim([0, 4])
legend('x \rightarrow z', 'z \rightarrow x')
title('Granger causality between channel x and channel z')
xlabel('Frequency (Hz)')
ylabel('Granger causality')

% chy <--> chz
[freq, s_yz] = ga_view(Fx2y, Fy2x, fs, chy, chz);
[~, s_zy] = ga_view(Fx2y, Fy2x, fs, chz, chy);
figure
plot(freq, s_yz, freq, s_zy, 'LineWidth', 2)
ylim([0, 4])
legend('y \rightarrow z', 'z \rightarrow y')
title('Granger causality between channel y and channel z')
xlabel('Frequency (Hz)')
ylabel('Granger causality')

%% ========================================================================
% subroutine
% =========================================================================
function [x, y, z] = constructModel(sig_len, lambda, sigma_x, sigma_y, sigma_z)
% sig_len           - signal length
% lambda            - parameter |lambda| < 1
% sigma_x,y,z      - noise STD for x, y, z channels

% parameters
% ----------
N = sig_len+50000; % length of create signal, including trainsient part

% channel x
% ---------
noise_x = sigma_x.*randn(N, 1);
x_all = noise_x;
x = x_all(end-sig_len+1:end); % get stable part and avoid transient part

% channel y
% ----------
noise_y = sigma_y.*randn(N, 1);
y_all = filter([0, 1], 1, x_all)+noise_y;
y = y_all(end-sig_len+1:end);

% channel z
% ---------
noise_z = sigma_z.*randn(N, 1);
w_all = filter([0, 1], 1, x_all)+noise_z;
z_all = filter(1, [1, -lambda], w_all);
z = z_all(end-sig_len+1:end);

end % function

% [EOF]
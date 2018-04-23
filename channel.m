% This work is licensed under the Creative Commons Attribution 4.0
% International License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
%
% Channel
rng('default')
% Time shift induced by the channel
tow_n = Tb*rand(1, 1);
% Damping factor on each channel, it has to be < 1
alpha_n = rand(1, 1);

% White gaussian noise AWGN: independant samples, null mean and unitary
% variance
noise = randn(numel(data), 1);

noise_filter = design(fdesign.lowpass('N,F3db', 10, 2/Tb, 1/Tn));

noise_f = filter(noise_filter, noise);

variance = 10;
standard_deviation = sqrt(variance);

noise_f = noise_f*standard_deviation;

shifted_data = delayseq(data,tow_n,1/Tn);

damped_data = alpha_n*shifted_data;

data = damped_data + noise_f;


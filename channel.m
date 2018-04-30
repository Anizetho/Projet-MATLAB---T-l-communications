% This work is licensed under the Creative Commons Attribution 4.0
% International License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

% AWGN: independant samples, null mean and unitary variance
noise = 0.2*randn([numel(data)+shift 1]);
% damping factor on each channel, it has to be <1
alpha = 0.8;

noise_filter = design(fdesign.lowpass('N,F3db', 30, 2*N*L/Tb, 2/Tn));
noise_f = filter(noise_filter, noise);

variance = 0.1;
std_dev = sqrt(variance);
noise_f = noise_f*std_dev;

data = alpha*data+noise_f;
data = [zeros(shift,1); data];

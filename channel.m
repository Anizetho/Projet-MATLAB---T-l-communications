% This work is licensed under the Creative Commons Attribution 4.0
% International License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

% gaussian noise
noise_1 = randn([numel(data)+shift 1]);
noise_f = design(fdesign.lowpass('N,F3db', 10, 1/(2*Tn), 1/Tn), 'butter');
noise_2 = filter(noise_f, noise_1);

% damping factor; between 0.60<=x<=0.90
alpha = (0.90-0.60)*rand([1 1])+0.60;

% increase noise with variance
variance = 1;
std_dev = sqrt(variance);
noise_3 = noise_2*std_dev;

data = [zeros(1,shift); data];
data = alpha*data+noise_3;

% This work is licensed under the Creative Commons Attribution 4.0
% International License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

% gaussian noise
noise_1 = randn([numel(data) 1]);
[bf,af] = butter(1, 0.5);
noise_f = ifft(freqz(bf, af, impulseL, 'whole', 1/Tn));
noise_2 = conv(noise_f, noise_1);
noise_2 = noise_2(impulseL/2:end-impulseL/2);

% damping factor; between 0.60<=x<=0.90
alpha = (0.90-0.60)*rand([1 1])+0.60;

% increase noise with variance
std_dev = sqrt(variance);
noise_3 = noise_2*std_dev;

data = alpha*data+noise_3;
data = [zeros(shift,1); data];

N0 = variance*numel(data);

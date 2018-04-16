% This work is licensed under the Creative Commons Attribution 4.0
% International License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
%
% Receiver parameters

sHighFFT = fft(data);
% cut the one-sided spectrum
sHighFFT = sHighFFT(1:ceil(end/2)+1,:);
% duplicate the spectrum for each channel
sHighFFT = sHighFFT * ones(1, N);
% calculate the bandwidth limits for each channel
cutoff = [carfreq-L/Tb carfreq+L/Tb];
% pre-allocate filters vector
ns = size(cutoff, 2);
H = cell(ns, 1);
% first channel lowpass
H{1} = design(fdesign.lowpass('N,F3db', 30, cutoff(1,2), 1/Tn), 'butter');
fdata(:,1) = filter(H{1}, data);
% others channels bandpass
for n = 2:ns
    H{n} = design(fdesign.bandpass('N,F3dB1,F3dB2', 30, cutoff(n,1), ...
                                   cutoff(n,2), 1/Tn), 'butter');
    fdata(:,n) = filter(H{n}, data);
end




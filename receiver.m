% This work is licensed under the Creative Commons Attribution 4.0
% International License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
%
% Receiver
% calculate the bandwidth limits for each channel
cutoff = [carfreq-L/Tb carfreq+L/Tb];
% pre-allocate filters vector
ns = size(cutoff, 2);
H = cell(ns, 1);
% first channel lowpass
H{1} = design(fdesign.lowpass('N,F3db', 30, cutoff(1,2), 1/Tn), 'butter');
sHigh(:,1) = filter(H{1}, data);
% others channels bandpass
for n = 2:ns
    H{n} = design(fdesign.bandpass('N,F3dB1,F3dB2', 30, cutoff(n,1), ...
                                   cutoff(n,2), 1/Tn), 'butter');
    sHigh(:,n) = filter(H{n}, data);
end

%fvtool(cell2mat(H))
sHighFFT = fft(sHigh, 2^nextpow2(len));

%% plot visual representation of the transmission
figure
subplot(2,1,1)
stem(linspace(0, len*Tn, len), sHigh)
title('Représentation temporelle du signal reçu')
xlabel('Times (s)')
ylabel('Amplitude (v)')
legend('Canal 1', 'Canal 2', 'Location', 'SouthWest')
grid

subplot(2,1,2)
plot(linspace(0, 1/Tn-1, 2^nextpow2(len)), ...
     20*log10(abs(sHighFFT)/2^nextpow2(len)))
ylim([-60 0])
title('Représentation fréquentielle du signal reçu')
xlabel('Frequency (Hz)')
ylabel('Puissance (dBm)')
legend('Canal 1', 'Canal 2', 'Location', 'North')
grid





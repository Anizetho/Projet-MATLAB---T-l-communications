% This work is licensed under the Creative Commons Attribution 4.0
% International License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

% calculate the bandwidth limits for each channel
cutoff = [carfreq-L/Tb carfreq+L/Tb];
% pre-allocate filters vector
ns = size(cutoff, 2);
H = cell(ns, 1);
% first channel lowpass
H{1} = design(fdesign.lowpass('N,F3db', 100, cutoff(1,2), 1/Tn), 'butter');
sHigh(:,1) = filtfilt(H{1}.sosMatrix, H{1}.ScaleValues, data);
% others channels bandpass
for n = 2:ns
    H{n} = design(fdesign.bandpass('N,F3dB1,F3dB2', 100, cutoff(n,1), ...
                                   cutoff(n,2), 1/Tn), 'butter');
    sHigh(:,n) = filtfilt(H{n}.sosMatrix, H{n}.ScaleValues, data);
end

% demodulate
s2 = sHigh ./ carrier;
% filter the canal noise
delay = mean(grpdelay(fir));
s2 = vertcat(s2, zeros(delay, N)); % add after time
s2 = filter(fir, 1, s2);           % filter and dephase
s2(1:delay, :) = [];               % remove before time

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
plot(linspace(0, 1/Tn-1, len), 20*log10(abs(fft(sHigh))/len))
ylim([-60 0])
xlim([0 79])
title('Représentation fréquentielle du signal reçu')
xlabel('Frequency (Hz)')
ylabel('Puissance (dBv)')
legend('Canal 1', 'Canal 2', 'Location', 'North')
grid

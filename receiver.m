% This work is licensed under the Creative Commons Attribution 4.0
% International License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

% calculate the bandwidth limits for each channel
cutoff = [carfreq-1/Tb carfreq+1/Tb]*2*Tn;
% pre-allocate filters matrix
H = zeros(impulseL, N);

% first channel lowpass
[b1,a1] = butter(10, cutoff(1,2), 'low');
imp1 = real(ifft(freqz(b1,a1)));
H(:,1) = imp1(1:impulseL);

% others channels bandpass
for n = 2:N
    [b1,a1] = butter(20, [cutoff(n,1) cutoff(n,2)], 'bandpass');
    imp1 = real(ifft(freqz(b1,a1)));
    H(:,n) = imp1(1:impulseL);
end

% pre-allocate to please Matlab then filter
len2 = size(data,1)+impulseL-1;
% convolute the signal with the impulses responses
s2High = conv2(data, 1, H);

% recreate localy the modulated start frame
% start_t = upfirdn(codesymbol(startSeq), rcos, beta)';
% start_t = start_t(1:end-span/2*beta,:);
% b1 = size(start_t, 1);
% a1 = cos(carfreq*linspace(0, 2*pi*b1*Tn, b1))';
% start_t = start_t .* a1;
% lagDiff = finddelay(start_t, s2High);

% generate localy the dephased carrier
carrier = cos(carfreq*linspace(0, 2*pi*len2*Tn, len2))';

% demodulate
s2 = s2High ./ carrier;

% filter the canal noise with the adequate filter
temp = s2;
lenr = size(rcos,2);
len3 = size(temp,1)+lenr-1;
s2 = zeros(len3,N);
for n = 1:N
    s2(:,n) = conv(rcos, temp(:,n));
end

% compensate the start trame
s2t = s2(span/2*beta+numel(startSeq)*beta+1:end, :);
% generate the index vector
s2i = 1:beta:beta*lena-(beta-1);
% extract the values at index
decoded = s2t(s2i,:);
% quantize the extracted values
decoded = decoded>0;

%% plot visual representation of the transmission
figure
subplot(2,1,1)
stem(linspace(0, len2*Tn, len2), s2High)
title('Représentation temporelle du signal reçu')
ylabel('Amplitude (v)'), xlabel('Times (s)')
legend(strcat("Canal ", num2str((1:N)')), 'Location', 'SouthWest')
grid

subplot(2,1,2)
plot(linspace(0, 1/Tn-1, len2), pow2db(abs(fft(s2High/len2)).^2/Z0)+30)
ylim([-60 10])
title('Représentation fréquentielle du signal reçu')
ylabel('Puissance (dBm)'), xlabel('Frequency (Hz)')
legend(strcat("Canal ", num2str((1:N)')), 'Location', 'North')
grid

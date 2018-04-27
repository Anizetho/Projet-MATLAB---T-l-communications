% This work is licensed under the Creative Commons Attribution 4.0
% International License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

% calculate the bandwidth limits for each channel
cutoff = [carfreq-1/Tb carfreq+1/Tb];
% pre-allocate filters vector
H = cell(N, 1);
% first channel lowpass
H{1} = design(fdesign.lowpass('N,F3db', 20, cutoff(1,2), 1/Tn), 'butter');
% others channels bandpass
for n = 2:N
    H{n} = design(fdesign.bandpass('N,F3dB1,F3dB2', 20, ...
        cutoff(n,1), cutoff(n,2), 1/Tn), 'butter');
end

% add offset to account for max group delay
maxgroupdelay = ceil(max(grpdelay(cell2mat(H))));
data = [data; zeros(max(maxgroupdelay), 1)];
% pre-allocate to please Matlab then filter
s2High = zeros(size(data,1), N);
for n = 1:N
    s2High(:,n) = filter(H{n}, data);
end

delay = finddelay(s1High(:,1), s2High(:,1));

% calculate the new time vector size accounting for the filters padding
len2 = size(data, 1);
% generate localy the dephased carrier
carrier = cos(carfreq*linspace(0, 2*pi*len2*Tn, len2))';

xc = []; lg = [];
for n = 1:N
    [axc, alg] = xcorr(carrier(:,n), s2High(:,n));
    xc = [xc axc];
    lg = [lg alg'];
end
[~, blo] = max(xc);
blu = lg(blo);

% demodulate
s2 = s2High ./ carrier;
% filter the canal noise with the adequate filter
rcosdelay = mean(grpdelay(rcos));
s2 = [s2; zeros(rcosdelay, N)];  % add after time
s2 = filter(rcos, 1, s2);        % filter and dephase
s2(1:rcosdelay, :) = [];         % remove before time

% find the start trame
lagDiff = zeros(1, N);
start_t = upfirdn(codesymbol(startSeq), rcos, beta);
start_t = start_t(:,1:end-span/2*beta-1);
for n = 1:N
    [acor,lag] = xcorr(s2(:,n), start_t);
    [~, I] = max(acor);
    lagDiff(n) = lag(I);
end
clear acor lag I
lagDiff = lagDiff+numel(start_t);
% compensate the start trame
s2t = s2(lagDiff(1:N):end, :);

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

%% decode data from signal
% remove upsampling offset
s2t = s2t(beta+1:end,:);
% remove left halfspan's
halfspan = span/2*beta;
s2t(end-halfspan-3*beta-1+7:end,:) = [];
% generate the indice vector
s2i = kron(ones(1, size(s2t, 1)/8), [1 zeros(1,beta-1)]);
s2i(end-beta+2:end) = [];
decoded = s2t(s2i~=0,:);
% round the extracted value
decoded(decoded>0) = 1;
decoded(decoded<=0) = 0;

% This work is licensed under the Creative Commons Attribution 4.0
% International License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
%
% Sender parameters
R = 10;         % bit rate
Tb = 1/R;       % bit duration
roll = 0.50;    % rolloff factor
L = 1;          % bandwidth xTb
beta = 4*N;     % upsampling factor
Tn = Tb/beta;   % upsample sampling rate
span = 10;      % FIR span for thinner bandwidth consumption
fir = rcosdesign(roll, span, beta);

% handle which maps 0,1 to -1,1
codesymbol = @(x)x.*2-1;

x = randi([0 1], M, N);
a = codesymbol(x);
s = upfirdn(a, fir, beta);
len = size(s, 1);

carfreq = (0:N-1)'*L*2/Tb; % carrier frequencies
carrier = cos(carfreq*linspace(0, 2*pi*len*Tn, len))';

%% plot impulsions
% iX = linspace(0, span/1e2, 1e2*span+1);
% iY = rcosdesign(roll, span, 1e2);
% plot(iX, iY' * ones(1, N) .* ...
%      cos(carfreq*linspace(0, 2*pi, span*1e2+1))')
% title("Représentation temporelle des impulsions utilisées")
% xlabel("Temps (s)")
% ylim([-max(iY)*1.1 +max(iY)*1.1])
% ylabel("Coefficient d'amplitude")
% legend(strcat("Canal ", num2str((1:N)')))
% grid
% clear('iX', 'iY')

%% modulate by carriers
sHigh = s .* carrier;
sHighFFT = fft(sHigh, 2^nextpow2(len));

%% plot visual representation of the transmission
figure
subplot(2,1,1)
stem(linspace(0, len*Tn, len), sHigh)
title('Représentation temporelle de la transmission non-filtrée')
xlabel('Times (s)')
ylabel('Amplitude (v)')
legend('Canal 1', 'Canal 2', 'Location', 'SouthEast')
grid

subplot(2,1,2)
plot(linspace(0, 1/Tn-1, 2^nextpow2(len)), 20*log10(abs(sHighFFT)/len))
ylim([-60 0])
title('Représentation fréquentielle de la transmission non-filtrée')
xlabel('Frequency (Hz)')
ylabel('Puissance (dBm)')
legend('Canal 1', 'Canal 2', 'Location', 'North')
grid

%% sum all channels before transmission
data = sum(sHigh, 2);

% delete temporary variables
clear('-regexp', 'sHigh*')

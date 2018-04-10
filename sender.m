% This work is licensed under the Creative Commons
% Attribution-NonCommercial-NoDerivatives 4.0 International License.
% To view a copy of this license, visit
% http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
%
% Sender parameters
R = 10;         % bit rate
Tb = 1/R;       % bit duration
roll = 0.00;    % rolloff factor
L = 1;          % bandwidth xTb
beta = 4*N;     % upsampling factor
Tn = Tb/beta;   % upsample sampling rate
span = 6;       % FIR span for thinner bandwidth consumption
fir = rcosdesign(roll, span, beta);

% handle which maps 0,1 to -1,1
codesymbol = @(x)x.*2-1;

x = randi([0 1], M, N);
a = codesymbol(x);
s = upfirdn(a, fir, beta);
len = size(s, 1);

carfreq = (0:N-1)'*2*L*(1+roll)/Tb; % carrier frequencies
carrier = cos(carfreq*linspace(0, 2*pi*len*Tn, len))';

%% plot impulsions
plot(linspace(0, span/(1e2), 1e2*span+1), ...
     rcosdesign(roll, span, 1e2)' * ones(1, N) .* ...
     cos(carfreq*linspace(0, 2*pi, span*1e2+1))');
title("Représentation temporelle des impulsions utilisées")
xlabel("Temps (s)")
ylim([-0.11 +0.11])
ylabel("Coefficient d'amplitude")
legend(strcat("Canal ", num2str((1:N)')))
grid

%% modulate by carriers and filter bandwidths
sHigh = s .* carrier;
sHighFFT = fft(sHigh);

% When the message contains one bit, the frequency spectrum
% cannot be split in two. No filter is needed.
if M ~= 1
    % cut the one-sided spectrum
    sHighFFTb = sHighFFT(1:ceil(end/2)+1,:);
    for n = 1:N
        % bandpass filter:
        % - before the bandwidth
        sHighFFTb(1:ceil((carfreq(n)-L*(1+roll)/Tb)*len*Tn),n) = 0;
        % - after the bandwidth
        sHighFFTb(ceil((carfreq(n)+L*(1+roll)/Tb)*len*Tn)+1:end,n) = 0;
    end
    % recreate the two-sided sprectum
    sHighFFTb = vertcat(sHighFFTb, conj(flipud(sHighFFTb(2:end-2,:))));
end

%% plot visual representation of the transmission
figure
subplot(2,2,1)
stem(linspace(0, len*Tn, len), sHigh)
title('Représentation temporelle de la transmission non-filtrée')
xlabel('Times (s)')
ylabel('Amplitude (v)')
legend('Canal 1 non-filtré', 'Canal 2 non-filtré', 'Location', 'SouthEast')
grid

subplot(2,2,3)
stem(linspace(0, 1/Tn-1, len), abs(sHighFFT)/len)
title('Représentation fréquentielle de la transmission non-filtrée')
xlabel('Frequency (Hz)')
ylabel('|Amplitude| (v)')
legend('Canal 1 non-filtré', 'Canal 2 non-filtré', 'Location', 'North')
grid

subplot(2,2,2)
sHighb = ifft(sHighFFTb);
stem(linspace(0, len*Tn, len), sHighb)
title('Représentation temporelle de la transmission filtrée')
xlabel('Times (s)')
ylabel('Amplitude (v)')
legend('Canal 1 filtré', 'Canal 2 filtré', 'Location', 'SouthEast')
grid

subplot(2,2,4)
stem(linspace(0, 1/Tn-1, len), abs(sHighFFTb)/len)
title('Représentation fréquentielle de la transmission non-filtrée')
xlabel('Frequency (Hz)')
ylabel('|Amplitude| (v)')
legend('Canal 1 filtré', 'Canal 2 filtré', 'Location', 'North')
grid

%% sum all channels before transmission
data = sum(sHighb, 2);

% delete tempory variables
clear('-regexp', 'sHigh*');

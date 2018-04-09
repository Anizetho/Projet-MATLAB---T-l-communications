% This work is licensed under the Creative Commons
% Attribution-NonCommercial-NoDerivatives 4.0 International License.
% To view a copy of this license, visit
% http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
%
% Sender parameters
R = 10;         % bit rate
Tb = 1/R;       % bit duration
roll = 0;       % rolloff factor
L = 1;          % bandwidth xTb
beta = 4*N;     % upsampling factor
Tn = Tb/beta;   % upsample sampling rate
fir = rcosdesign(roll, 6, beta);

% handle which maps 0,1 to -1,1
codesymbol = @(x)x.*2-1;

x = randi([0 1], M, N);
a = codesymbol(x);
%x = x + randn(size(x))*1e-2;  % add noise
s = upfirdn(a, fir, beta);

% transmission length
len = size(s, 1);

carfreq = (0:N-1)'*2*L/Tb; % carriers frequencies
carrier = cos(carfreq/(len*Tn)*linspace(0, 2*pi*len*Tn, len))';

sHigh = s .* carrier;
sHighFFT = fft(sHigh);

% When the message contains one bit, the frequency sprectrum
% cannot be split in two. No filter is needed.
if M ~= 1
    % cut the one-sided spectrum
    sHighFFTb = sHighFFT(1:ceil(end/2)+1,:);
    for n = 1:N
        % barbarian bandpass filter
        sHighFFTb(1:carfreq(n)-L*1/Tb,n) = 0;
        sHighFFTb(carfreq(n)+L*1/Tb+1:end,n) = 0;
    end
    % recreate the two-sided sprectum
    sHighFFTb = vertcat(sHighFFTb, conj(flipud(sHighFFTb(2:end-2,:))));
end

subplot(2,2,1)
stem(sHigh)
grid
subplot(2,2,3)
stem(abs(sHighFFT)/(M*beta))
grid
subplot(2,2,2)
sHighb = ifft(sHighFFTb);
stem(sHighb)
grid
subplot(2,2,4)
stem(abs(sHighFFTb)/(M*beta))
grid

data = sum(sHighb, 2);

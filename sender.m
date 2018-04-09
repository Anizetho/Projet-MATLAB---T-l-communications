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
fir = rcosdesign(roll, 6, beta);

% handle which maps 0,1 to -1,1
codesymbol = @(x)x.*2-1;

x = randi([0 1], M, N);
a = codesymbol(x);
%x = x + randn(size(x))*1e-2;  % add noise
s = upfirdn(a, fir, beta);

% transmission length
len = size(s, 1);

carfreq = (0:N-1)'*2*L*(1+roll)/Tb; % carrier frequencies
carrier = cos(carfreq*linspace(0, 2*pi*len*Tn, len))';

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

subplot(2,2,1)
stem(linspace(0, len*Tn, len), sHigh)
grid
subplot(2,2,3)
stem(linspace(0, 1/Tn-1, len), abs(sHighFFT)/len)
grid
subplot(2,2,2)
sHighb = ifft(sHighFFTb);
stem(linspace(0, len*Tn, len), sHighb)
grid
subplot(2,2,4)
stem(linspace(0, 1/Tn-1, len), abs(sHighFFTb)/len)
grid

data = sum(sHighb, 2);

% delete tempory variables
%clear('-regexp', 'sHigh*');

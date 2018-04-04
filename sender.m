% Paramètres émetteur
M = 10;     % nombre de bits
R = 10;     % débit binaire bits/s
Tb = 1/R;   % durée d'un bit
roll = 0;   % facteur de 'rolloff'
L = 2;      % largeur de bande xTb
beta = 4*N; % suréchantillonage (donnée dans l'énoncé)
Tn = 1/beta*Tb; % nouvelle fréquence d'échantillonage
fir = rcosdesign(roll, 2, beta);

carfreq = (0:N-1)'*L/Tb; % fréquences des porteuses
carrier = cos(carfreq*linspace(0, 2*pi, 1/Tn))';

% fonction qui map 0,1 en -1,1
codesymbol = @(x)x.*2-1;

x = randi([0 1], M, N);
a = codesymbol(x);
al = upsample(a, beta);
%x = x + randn(size(x))*1e-2;  % add noise
s = filter(fir, 1, al);

sHigh = s .* carrier;
sHighFFT = fft(sHigh);
sHighFFTfiltered = sHighFFT;

for x = 1:N
    sHighFFTfiltered(carfreq(x)+1/Tb+1:end/2, x) = 0;
    sHighFFTfiltered(1:carfreq(x)-1/Tb, x) = 0;
    
    sHighFFTfiltered(end-carfreq(x)+1/Tb+2:end, x) = 0;
    sHighFFTfiltered(end/2: end-carfreq(x)-1/Tb+1, x) = 0;
end

subplot(2,2,1)
stem(sHigh)
grid
subplot(2,2,3)
stem(abs(sHighFFT)/(M*beta))
grid
subplot(2,2,2)
stem(ifft(sHighFFTfiltered))
grid
subplot(2,2,4)
stem(abs(sHighFFTfiltered)/(M*beta))
grid

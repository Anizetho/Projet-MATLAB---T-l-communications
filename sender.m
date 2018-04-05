% Paramètres émetteur
R = 10;         % débit binaire bits/s
Tb = 1/R;       % durée d'un bit
roll = 0;       % facteur de 'rolloff'
L = 1;          % largeur de bande xTb
beta = 4*N;     % suréchantillonage (donnée dans l'énoncé)
Tn = 1/beta*Tb; % nouvelle fréquence d'échantillonage
fir = rcosdesign(roll, 2, beta);

carfreq = (0:N-1)'*2*L/Tb; % fréquences des porteuses
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
sHighFFT = sHighFFT(1:end/2+1,:); % one-sided spectrum
sHighFFTb = sHighFFT;

for n = 1:N
    % filtre passe-bande "à la brute"
    sHighFFTb(carfreq(n)+L*1/Tb+1:end, n) = 0;
    sHighFFTb(1:carfreq(n)-L*1/Tb, n) = 0;
end

% reconstruction des spectres
sHighFFT  = vertcat(sHighFFT , flip(sHighFFT (2:end-1,:)));
sHighFFTb = vertcat(sHighFFTb, flip(sHighFFTb(2:end-1,:)));

subplot(2,2,1)
stem(sHigh)
grid
subplot(2,2,3)
stem(abs(sHighFFT)/(M*beta))
grid
subplot(2,2,2)
sHighb = ifft(real(sHighFFTb));
stem(sHighb)
grid
subplot(2,2,4)
stem(abs(sHighFFTb)/(M*beta))
grid

data = sum(sHighb, 2);

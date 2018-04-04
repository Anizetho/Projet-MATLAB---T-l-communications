% Paramètre système
K = 4;    % nombre de modules
N = 4;    % nombre de ressources physique
% Paramètres émetteur
M = 10;   % nombre de bits
R = 10;   % débit binaire bits/s
Tb = 1/R; % durée d'un bit

% Paramètres du FIR
alpha = 0; % facteur de 'rolloff'
L = 2;     % largeur de bande xTb

beta = 4*N-2; % suréchantillonage (donnée dans l'énoncé)
Tn = 1/beta*Tb; % nouvelle fréquence d'échantillonage
fir = rcosdesign(0, 2, beta/2); % filtre en cosinus surélevé

quafreqs = 2*pi*2*(0:N-1)'/Tb; % fréquences des porteuses
quarries = cos(quafreqs*linspace(0,1,1/Tn));

% fonction qui map 0,1 en -1,1
codesymbol = @(x)x.*2-1;

x = randi([0 1], M, N);
a = codesymbol(x);
al = upsample(a, beta);
%x = x + randn(size(x))*1e-2;  % add noise
s = filter(fir, 1, al);

sfft = fft(s);
sfft(1/(M*Tn)+1:end,:) = 0; % filtre passe-bas "à la brute"
sLow = ifft(sfft);

sLow = sLow .* quarries';
sLowFFT = fft(sLow);

subplot(2,1,1)
stem(sLow(:,1)+...
     sLow(:,2)+...
     sLow(:,3)+...
     sLow(:,4));
grid
subplot(2,1,2)
stem(abs(sLowFFT)/(M*beta))
grid

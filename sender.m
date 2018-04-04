% Param�tre syst�me
K = 4;    % nombre de modules
N = 4;    % nombre de ressources physique
% Param�tres �metteur
M = 10;   % nombre de bits
R = 10;   % d�bit binaire bits/s
Tb = 1/R; % dur�e d'un bit

% Param�tres du FIR
alpha = 0; % facteur de 'rolloff'
L = 2;     % largeur de bande xTb

beta = 4*N-2; % sur�chantillonage (donn�e dans l'�nonc�)
Tn = 1/beta*Tb; % nouvelle fr�quence d'�chantillonage
fir = rcosdesign(0, 2, beta/2); % filtre en cosinus sur�lev�

quafreqs = 2*pi*2*(0:N-1)'/Tb; % fr�quences des porteuses
quarries = cos(quafreqs*linspace(0,1,1/Tn));

% fonction qui map 0,1 en -1,1
codesymbol = @(x)x.*2-1;

x = randi([0 1], M, N);
a = codesymbol(x);
al = upsample(a, beta);
%x = x + randn(size(x))*1e-2;  % add noise
s = filter(fir, 1, al);

sfft = fft(s);
sfft(1/(M*Tn)+1:end,:) = 0; % filtre passe-bas "� la brute"
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

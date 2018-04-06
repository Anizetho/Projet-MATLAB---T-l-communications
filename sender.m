% Param�tres �metteur
R = 10;         % d�bit binaire bit/s
Tb = 1/R;       % dur�e d'un bit
roll = 0;       % facteur de 'rolloff'
L = 1;          % largeur de bande xTb
beta = 4*N;     % sur�chantillonage (donn�e dans l'�nonc�)
Tn = Tb/beta;   % nouvelle fr�quence d'�chantillonage
fir = rcosdesign(roll, 6, beta);

% fonction qui map 0,1 en -1,1
codesymbol = @(x)x.*2-1;

x = randi([0 1], M, N);
a = codesymbol(x);
%x = x + randn(size(x))*1e-2;  % add noise
s = upfirdn(a, fir, beta);

% longueur de transmission
len = size(s, 1);

carfreq = (0:N-1)'*2*L/Tb; % fr�quences des porteuses
carrier = cos(carfreq/(len*Tn)*linspace(0, 2*pi*len*Tn, len))';

sHigh = s .* carrier;
sHighFFT = fft(sHigh);

% cut the one-sided spectrum
sHighFFTb = sHighFFT(1:ceil(end/2)+1,:);

for n = 1:N
    % filtre passe-bande "� la brute"
    sHighFFTb(1:carfreq(n)-L*1/Tb,n) = 0;
    sHighFFTb(carfreq(n)+L*1/Tb+1:end,n) = 0;
end

% recreate the two-sided sprectum
sHighFFTb = vertcat(sHighFFTb, conj(flipud(sHighFFTb(2:end-1,:))));

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

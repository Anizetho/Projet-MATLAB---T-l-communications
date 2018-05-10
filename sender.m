% This work is licensed under the Creative Commons Attribution 4.0
% International License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

x = randi([0 1], M, N);
% append the start sequence
x = [startSeq'*ones(1, N); x];
a = codesymbol(x);
% shape to impulse
rcos = rcosdesign(roll, span, beta);
a = upsample(a, beta);
s1 = conv2(rcos, 1, a);
len1 = size(s1, 1);
% carrier frequencies
carfreq = (0:N-1)'*L*2/Tb;

%% plot impulsions
iX = linspace(0, span/1e2, 1e2*span+1);
iY = rcosdesign(roll, span, 1e2);
plot(iX, iY' * ones(1, N) .* ...
     cos(carfreq*linspace(0, 2*pi, span*1e2+1))')
ylim([-max(iY)*1.1 +max(iY)*1.1])
title("Representation temporelle des impulsions utilisees")
ylabel("Coefficient d'amplitude"), xlabel("Temps (s)")
legend(strcat("Canal ", num2str((1:N)')))
grid
clear iX iY

%% modulate by carriers
t = (0:Tn:(len1-1)*Tn)'*ones(1,N);
s1High = s1.*cos(2*pi*carfreq'.*t);

% normalise power to 'pwr' mW
pwrTimesSec = pwr*len1*Tn; % mW per second * transmission time
avgPower = bandpower(s1High)/Z0*1000/(pwrTimesSec);
s1High = s1High./sqrt(avgPower);

% sum all channels before transmission
data = sum(s1High, 2);

% calculate the energy in 1 bit for error measurements
Eb = bandpower(data); % overall Watt
Eb = Eb*len1*Tn;      % convert to Joule
Eb = Eb/(M+16)/N;     % divide by qte of bits

%% plot visual representation of the transmission
figure
subplot(2,1,1)
stem(linspace(0, len1*Tn, len1), s1High)
title('Representation temporelle du signal envoye')
ylabel('Amplitude (v)'), xlabel('Times (s)')
legend(strcat("Canal ", num2str((1:N)')), 'Location', 'SouthWest')
grid

subplot(2,1,2)
plot(linspace(0, 1/Tn-1, len1), pow2db(abs(fft(s1High/len1)).^2/Z0))
ylim([-60 0])
title('Representation frequentielle du signal envoye')
ylabel('Puissance (dBm)'), xlabel('Frequency (Hz)')
legend(strcat("Canal ", num2str((1:N)')), 'Location', 'North')
grid

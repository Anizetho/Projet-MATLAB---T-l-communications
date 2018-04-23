% This work is licensed under the Creative Commons Attribution 4.0
% International License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
close all,
% System
K = 4;          % module number
N = 2;          % available channels
M = 45;         % message size (bits)
% Sender
R = 10;         % bit rate
Tb = 1/R;       % bit duration
roll = 0.00;    % rolloff factor
L = 1;          % bandwidth xTb
beta = 4*N;     % upsampling factor
Tn = Tb/beta;   % upsample sampling rate
span = 20;      % FIR span for thinner bandwidth consumption
fir = rcosdesign(roll, span, beta);
% Canal
Z0 = 50;        % characteristic impedance

% generate data and send it
sender
% filter data and read it
receiver

% compare the generate signal in sender to the extracted signal in receiver
figure
subplot(2,1,1)
stem(linspace(0, len*Tn, len), s1(:,1));
title('Signal normalisé envoyé dans l''émeteur')
xlabel('Temps de transmission (s)')
ylabel('Amplitude du signal')
grid

subplot(2,1,2)
stem(linspace(0, len*Tn, len), s2(:,1), 'Color', [0.85 0.33 0.1]);
title('Signal recomposé dans le receveur')
xlabel('Temps de transmission (s)')
ylabel('Amplitude du signal')
grid

% tell me the truth, doctor
all((x-decoded)==0)

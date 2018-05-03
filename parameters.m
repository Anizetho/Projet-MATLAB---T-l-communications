% This work is licensed under the Creative Commons Attribution 4.0
% International License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

codesymbol = @(x)x.*2-1;

% System
N = 3;          % available channels
M = 45;         % message size (bits)

% Sender
R = 10;         % bit rate
Tb = 1/R;       % bit duration
roll = 0.40;    % rolloff factor
L = 1.25;       % bandwidth xTb
beta = 4*N*L;   % upsampling factor
Tn = Tb/beta;   % upsample sampling rate
span = 20;      % rcos span for thinner bandwidth consumption
pwr = 4;        % channel power in mW

% Channel
Z0 = 50;        % characteristic impedance
shift = 4;      % samples delay

% Receiver
impulseL = 128;
startSeq = [1 0 1 0 1 0 1 0 ... % test the channel response
            1 1 1 1 1 1 1 1];   % set an unique sequence

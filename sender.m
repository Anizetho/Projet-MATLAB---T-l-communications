clear; close all;  clc
% Param�tre syst�me
K = 4;    % nombre de modules
N = 3;    % nombre de ressources physique
% Param�tres �metteur
M = 10;   % nombre de bits
R = 10;   % d�bit binaire bits/s
Tb = 1/R; % dur�e d'un bit

beta = 4*N-2;   % sur�chantillonage (donn�e dans l'�nonc�)
Tn = beta * Tb; % nouvelle fr�quence d'�chantillonage

% fonction qui map 0,1 en -1,1
codesymbol = @(x)x.*2-1;

x = randi([0 1], 1, M);
a = codesymbol(x);
%a = kron(a, ones(1, N));
%fir = rcosdesign(0.0, 2, 3);
%x = x + randn(size(x))*1e-2;  % add noise
%a = filter(fir, 1, a);

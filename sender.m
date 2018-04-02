clear; close all;  clc
% Paramètre système
K = 4;    % nombre de modules
N = 3;    % nombre de ressources physique
% Paramètres émetteur
M = 10;   % nombre de bits
R = 10;   % débit binaire bits/s
Tb = 1/R; % durée d'un bit

beta = 4*N-2;   % suréchantillonage (donnée dans l'énoncé)
Tn = beta * Tb; % nouvelle fréquence d'échantillonage

% fonction qui map 0,1 en -1,1
codesymbol = @(x)x.*2-1;

x = randi([0 1], 1, M);
a = codesymbol(x);
%a = kron(a, ones(1, N));
%fir = rcosdesign(0.0, 2, 3);
%x = x + randn(size(x))*1e-2;  % add noise
%a = filter(fir, 1, a);

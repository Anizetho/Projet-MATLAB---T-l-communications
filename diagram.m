% This work is licensed under the Creative Commons Attribution 4.0
% International License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

% 2-PAM best case
t = linspace(0, 10, 1e3);
y = 1/2*erfc(sqrt(10.^(t/10)));
semilogy(t, y)
grid

% our case
dB2test = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10];
tries = numel(dB2test);
BER = zeros([1 tries]);
ebn0 = zeros([1 tries]);

for uniqIDX = 1:tries
    forcedPwr = dB2test(uniqIDX);
    main;
    BER(uniqIDX) = sum(errorRate)/N;
end

hold on, semilogy(ebn0, BER), hold off

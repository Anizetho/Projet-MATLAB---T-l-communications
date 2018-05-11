% This work is licensed under the Creative Commons Attribution 4.0
% International License. To view a copy of this license, visit
% http://creativecommons.org/licenses/by/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.

% 2-PAM best case
t = linspace(0, 10, length(data));
y = 1/2*erfc(sqrt(10.^(t/10)));
semilogy(t, y)
grid

% our case
BER = zeros([1 5]);
ebn0 = zeros([1 5]);

for uniqIDX = 0:4
    variance = 1/(2^uniqIDX);
    main;
    Ptotal = sum(data.^2);
    Pnoise = variance*length(data);
    BER(uniqIDX+1) = sum(errorRate)/3;
    ebn0(uniqIDX+1) = Ptotal/Pnoise;
end

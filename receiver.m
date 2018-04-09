% This work is licensed under the Creative Commons
% Attribution-NonCommercial-NoDerivatives 4.0 International License.
% To view a copy of this license, visit
% http://creativecommons.org/licenses/by-nc-nd/4.0/ or send a letter to
% Creative Commons, PO Box 1866, Mountain View, CA 94042, USA.
%
% Receiver parameters

sHighFFT = fft(data);
% cut the one-sided spectrum
sHighFFT = sHighFFT(1:ceil(end/2)+1,:);
% duplicate the spectrum for each channel
sHighFFT = sHighFFT * ones(1, N);
% calculate the bandwidth limits for each channel
cutoff = [carfreq-L/Tb carfreq+L/Tb];

% TODO: separate spectrum

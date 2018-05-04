close all

gd = zeros(512, N);
hold on

% first channel lowpass
[tmp1,tmp2] = butter(10, cutoff(1,2));
gd(:,1) = grpdelay(tmp1, tmp2);
[h,f] = freqz(tmp1, tmp2, impulseL, 'whole', 1/Tn);
plot(f(1:ceil(end/2)), ...
    20*log10(abs(h(1:ceil(end/2)))));

% others channels bandpass
for n = 2:N
    [tmp1,tmp2] = butter(10, [cutoff(n,1) cutoff(n,2)]);
    gd(:,n) = grpdelay(tmp1, tmp2);
    [h,f] = freqz(tmp1, tmp2, impulseL, 'whole', 1/Tn);
    plot(f(1:ceil(end/2)), ...
        20*log10(abs(h(1:ceil(end/2)))));
end

xlim([0 75]);
xlabel('Fréquence (Hz)')
ylabel('Amplitude (dB)')
grid, hold off

figure, plot(gd), grid
xlabel('Fréquence (Hz)')
ylabel('Samples (sample x rad)')

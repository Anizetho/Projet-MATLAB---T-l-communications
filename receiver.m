% Receiver parameters
% none...

sHighFFT = fft(data);

for n = 1:N
    if n == 1
        z(:,n) = sHighFFT(1:1/Tb);
    else
        z(:,n) = sHighFFT(carfreq(n)-1/Tb+1:carfreq(n)+1/Tb);
    end
end

%input : xxx.wav
%output: N * frequence vector array
infilename = 'a_c.wav';
[y,Fs] = audioread(infilename);
%sound(y,Fs);
L = 4096;
%L = 4096
for i =4096:4096:88200
    Y(i) = fft(y(i-4095:i),L);
end
%Y = fft(y,L);
P2 = abs(Y/L);
P1 = P2(1:L/2+1);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
%figure
%semilogx(f,P1)
plot(f,P1) 
axis([20 2000 0 0.15])
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
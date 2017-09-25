clear;
clc;
Fs=1000;
L = 2000;
T = 1/Fs;
t = (0:L-1)*T;
y = sin(2*pi*t*100.5);

N = 1000;
index = 1;
for i =N:N:L
    Y(:,index) = fft(y(i-N+1:i),N);
    index = index +1;
end

    %Y = fft(y,N);
P2 = abs(Y/N);
P1 = P2(1:N/2+1,:);
P1(2:end-1) = 2*P1(2:end-1);

[M,I] = max(P1);
f = (I.*(Fs/N));
f = Fs*(0:(N/2))/N;
plot(f,P1) 


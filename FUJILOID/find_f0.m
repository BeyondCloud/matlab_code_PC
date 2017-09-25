%input : xxx.wav
%output: N * frequence vector array
clear;
clc;
infilename = 'a_c.wav';
%[y,Fs] = audioread(infilename);
%sound(y,Fs);
%y_len = size(y,1);
L = 44100;
Fs=44100;
T = 1/Fs;
t = (0:L-1)*T;
y = sin(2*pi*t*100);

N = 2.^13;
index = 1;
for i =N:N/2:L
    Y(:,index) = fft(y(i-N+1:i),N);
    index = index +1;
end 

    %Y = fft(y,N);
P2 = abs(Y/N);
P1 = P2(1:N/2+1,:);
P1(2:end-1) = 2*P1(2:end-1);

[M,I] = max(P1);
f = (I.*(Fs/N));
f
f_tbl = Fs*(0:(N/2))/N


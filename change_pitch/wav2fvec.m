%input : xxx.wav
%output: N * frequence vector array
infilename = 'a_c.wav';
[y,Fs] = audioread(infilename);
%sound(y,Fs);
L = 4096;
%L = 4096
index = 1;
for i =4096:4096:88200
    Y(:,index) = fft(y(i-4095:i),L);
    index = index +1;
end 
sqr2_12 =  2^(5/12);
for i =1:4096
    Y_shift(i,:) = Y(ceil(i/sqr2_12),:);
end
    %Y = fft(y,L);
P2 = abs(Y/L);
P1 = P2(1:L/2+1,:);
P1(2:end-1) = 2*P1(2:end-1);
f = Fs*(0:(L/2))/L;
%figure
%semilogx(f,P1)
plot(f,P1) 
axis([20 3000 0 0.15])
title('Single-Sided Amplitude Spectrum of X(t)')
xlabel('f (Hz)')
ylabel('|P1(f)|')
for i = 1:size(Y,2)
    X(:,i) = ifft(Y_shift(:,i),L);
end
wavout = reshape(X,[4096*21,1]);

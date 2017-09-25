Fs = 44100;
T_len = 0.5;
t = 0:1/Fs:T_len-1/Fs;
y = cos(2*pi*123.6*t)+randn(size(t));
ydft = fft(y);
freq = 0:Fs/length(y):Fs/2;
if(mod(length(y),2) == 0)
    ydft = ydft(1:length(y)/2+1);
else
    ydft = ydft(1:floor(length(y)/2)+1);
end    
plot(freq,abs(ydft))
[maxval,idx] = max(abs(ydft));
freq(idx)  %this is frequency corresponding to max value

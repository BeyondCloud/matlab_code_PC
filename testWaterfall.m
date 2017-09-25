
y=audioread('a.wav'); 
y_len = size(y,1);
Fs = 44100;
step = 1/44100;  
t = (step:step:y_len/Fs)';
in = [t y];
waterfall_FFT;

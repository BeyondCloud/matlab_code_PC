[x,fs] = audioread('M_GT.wav');
y = resample( x ,700000 ,fs); 
t = 0:1/1e4:2;
% chirp(t,f0,t1,f1)
x = chirp(t,200,2,210)';
spectrogram(y,256,250,256,1e3,'yaxis');
Fs = 44100;
param.sr = 10000;
[f0 t] = yin_f0(y',param);
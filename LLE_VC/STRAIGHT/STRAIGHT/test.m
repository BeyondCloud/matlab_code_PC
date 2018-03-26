clear all;
%addpath C:\Program Files\MATLAB/R2008a\work\STRAIGHT\STRAIGHTV40_006b;

[x,fs]=wavread('C:/Program Files/MATLAB/R2008a/work/STRAIGHT/STRAIGHTV40_006b/DS1.wav');
%soundsc(x,fs);
%f0raw = MulticueF0v14(x,fs);
%ap = exstraightAPind(x,fs,f0raw);
%prmF0in.DisplayPlots=0;
[f0raw,ap]=exstraightsource(x,fs);

%prmPin.DisplayPlots=0;
n3sgram=exstraightspec(x,f0raw,fs);

%prmS.groupDelayStandardDeviation=0.5;
sy = exstraightsynth(f0raw,n3sgram,ap,fs);
%wavwrite(sy/32768,fs,16,'C:/MATLAB701/work/speech process/STRAIGHT/DS1syn.wav');

soundsc(sy,fs);


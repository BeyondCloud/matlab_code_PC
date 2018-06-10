% clear;clc;
%load align wave
[x_pit fs] = audioread('song_short.wav');
[x_lyc fs] = audioread('Trump_short.wav');
len = min(length(x_pit),length(x_lyc));
x_pit = x_pit(1:len);
x_lyc = x_lyc(1:len);

param.hop = 32;
param.sr = fs;
[feat,t] = yin_best(x_lyc,param);  %get freq_tbl
f0 = feat.f0;
best = feat.best ;
pwr = feat.pwr;
best_idx = find(best == 0);
idx_exclude = 1:length(f0);
idx_exclude(ismember(idx_exclude,best_idx))=[];
f0(idx_exclude) = nan;
f0(find(f0>350)) = nan;
f0_lyc = fix_f0(f0);
plot(feat.f0);
figure
plot(f0);


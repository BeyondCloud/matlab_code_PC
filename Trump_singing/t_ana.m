% clear;clc;
%load align wave
[x_talk fs] = audioread('t1.wav');
[x_sing fs] = audioread('s1.wav');
% x_talk = x_talk(10000:14000);
len = min(length(x_sing),length(x_talk));
x_sing = x_sing(1:len);
x_talk = x_talk(1:len);

param.hop = 1;
param.sr = fs;
[feat,t] = yin_best(x_talk,param);  %get freq_tbl
f0 = feat.f0;
best = feat.best ;
pwr = feat.pwr;
best_idx = find(best == 0);
idx_exclude = 1:length(f0);
idx_exclude(ismember(idx_exclude,best_idx))=[];
f0(idx_exclude) = nan;
f0(find(f0>500)) = nan;
f0_lyc = fix_f0(f0);
plot(f0_lyc);
% figure
% plot(f0);

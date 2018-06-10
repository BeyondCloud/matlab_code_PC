% clear;clc;
%load align wave



param.hop = 1;
param.sr = fs;
[feat,t] = yin_best(result,param);  %get freq_tbl
f0 = feat.f0;
best = feat.best ;
pwr = feat.pwr;
best_idx = find(best == 0);
idx_exclude = 1:length(f0);
idx_exclude(ismember(idx_exclude,best_idx))=[];
f0(idx_exclude) = nan;
f0(find(f0>500)) = nan;
f0_syn = fix_f0(f0);
plot(f0_syn);
% figure
% plot(f0);

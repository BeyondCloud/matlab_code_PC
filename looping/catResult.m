clear;
clc;
[y,Fs] = audioread('result.wav');
y_clip = y(42442:137841);
y_len  = size(y_clip,1)/2;
y_clip_A = y_clip(1:y_len);
y_clip_B = y_clip(y_len+1:end);
A_in = y_clip_A.*[1/y_len:1/y_len:1]';
B_out = y_clip_B.*[1:-1/y_len:1/y_len]';
mid = A_in+B_out;
result = [y_clip_A;mid;mid;mid;y_clip_B];





% N  = 5000;
% mean_h = max(y_clip(1:N));
% mean_t = max(y_clip(end-N+1:end));
% del_mean = mean_t-mean_h;
% y_clip_a = y_clip - [del_mean/size(y_clip,1):del_mean/size(y_clip,1):del_mean]';
% yya = [y_clip_a;y_clip_a];
% yy = [y_clip;y_clip];

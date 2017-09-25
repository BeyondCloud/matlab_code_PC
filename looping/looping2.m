clear; clc; close all;
[x,fs] = audioread('_a_ao.wav');
val=0;
init_h_i = 60000
init_t_i = 67000
find_max_win_len = 1000;
lap_len = 1000;
[val,h_i] = max(x(init_h_i:init_h_i+find_max_win_len));
[val,t_i] = max(x(init_t_i:init_t_i+find_max_win_len));

x = x(h_i+init_h_i:t_i+init_t_i);
x_len = size(x,1);
a = [1/lap_len:1/lap_len:1]';
b = flipud(a);

head=x(1:lap_len);
tail=x(x_len-lap_len+1:x_len);

lap = tail.*b +head.*a;
mid = x(lap_len+1:x_len-lap_len+1);
result = [lap;mid];

 result = repmat(result,8,1);
%  sound(result,44100);
% hold on;
% plot(lap);
%plot(x(x_len-1000:x_len).*b);
%plot(x(1:1001).*a);
%  plot(head);
%  plot(tail);
 
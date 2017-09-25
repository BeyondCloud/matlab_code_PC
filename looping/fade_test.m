
clear; clc; close all;
[y,fs] = audioread('_a_ao.wav');
x = y(33780:45490);

%% windowing
nove = fs * 0.1;
f_in = (0:1/(nove-1):1)';
f_out = flipud(f_in);
x_len  =size(x,1);
lap = x(x_len-nove+1:x_len).*f_out+x(1:nove).*f_in;
mid = x(nove+1:x_len-nove)
result = [x(1:x_len-nove+1);lap;mid;lap;mid;lap;mid;lap];

sound(result,fs);


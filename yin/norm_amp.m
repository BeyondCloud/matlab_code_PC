clc;clear;
[x,fs] = audioread('a.wav');
x_len = size(x,1);
win = 480;
hop = 240;
pwr_len = floor((x_len-win)/hop)+1;
y = zeros(x_len,1);
pwr = zeros(pwr_len,1);
i = win;
pwr_i = 1;
while i<x_len
    pwr(pwr_i) = sqrt(sum(x(i-win+1:i).^2)/win);
    pwr_i=pwr_i+1;
    i = i+hop;
end
plot(pwr);
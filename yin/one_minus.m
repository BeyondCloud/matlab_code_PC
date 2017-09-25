clc;clear;
[x,fs] = audioread('a.wav');
x_len = size(x,1);
i=5;
y = zeros(x_len,1);
while i<x_len
    delta(i) = mean(x(i-4:i));
    i=i+1;
end
plot(delta);

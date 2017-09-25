clc;clear;
[x,fs] = audioread('a.wav');
x_len = size(x,1);
i=2;
y = zeros(x_len,1);
y(1) = x(1);
f = @(t)exp(-(0.5-t)*10)./(1+exp(-(0.5-t)*10));
while i<x_len
     y(i) = x(i-1)+sign(x(i)-x(i-1))*f(abs(x(i)-x(i-1)));
     delta(i) = x(i)-x(i-1);
    i=i+1;
end
plot(y);

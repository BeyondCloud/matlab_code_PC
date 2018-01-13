clear; clc; close all;
[x,fs] = audioread('_a_ao.wav');
x = x(46321:52850);
x_len = size(x,1);
a = [0:0.001:1]';
a = 1-a.^2;
b = flipud(a);

lap = x(x_len-1000:x_len).*b +x(1:1001).*a;
mid = x(1002:x_len-1001);
result = [lap;mid;lap;mid];
result = [result;result];
result = [result;result];
hold on;
% plot(lap);
%plot(x(x_len-1000:x_len).*b);
%plot(x(1:1001).*a);
 plot(result);


% sound(x,fs);

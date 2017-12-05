clear;
clc;

[y,Fs] = audioread('Xia_a.wav');
y = y(3000:end-3000);
[env_up,env_down] = envelope(y,500,'peak');
err = env_up-env_down;
fix_y = y.*(0.3./err);
subplot(2,1,1);
plot(y);
subplot(2,1,2);
plot(fix_y);
audiowrite('result.wav',fix_y,44100);
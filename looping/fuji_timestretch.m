clear;clc;
[y,Fs] = audioread('a.wav');
unit_y = unit_amp(y,0.3,450);
audiowrite('my_a_unit.wav',unit_y,44100);

%clip signal will be used to create mid sig
% y_clip = y(1:(size(y,1)-mod(size(y,1),2)));
y_clip = unit_y((42442:137841));

y_len  =(size(y_clip,1)/2);

%output signal front & end
y_clip_A = y_clip(1:floor(y_len));
y_clip_B = y_clip(floor(y_len)+1:end);

%mid signal
A_in = y_clip_A.*[1/y_len:1/y_len:1]';
B_out = y_clip_B.*[1:-1/y_len:1/y_len]';
mid = A_in+B_out;

cat_sig= [y_clip_A;mid;mid;mid;mid;mid;mid;y_clip_B];

result = unit_amp(cat_sig,0.3,650);
fs = 44100;
frequency = 261;
freq = 329;
phaseDelta =(2.0 * pi * frequency / 44100);
phaseD =(2.0 * pi * freq / 44100);
phase = 0;
p=0;

for i = 1:48000
    y(i) = sin(phase) +sin(p);
    phase = mod(phase + phaseDelta , pi * 2);
    p = mod(p + phaseD , pi * 2);
    
end

for i = 1:4800
    x(i)=y(i);
end
soundsc(y,fs,16);
stem(x);

% fs = 44100; % Hz  1000 through 384000.
% t = 0:1/fs:0.1; % seconds
% f1 = 261; % Hz
% f2 = 329;
% f3 = 392;
% y =sin(2*pi*f1*t) %+ sin(2*pi*f2*t) + sin(2*pi*f3*t);
% soundsc(y,fs,16);
% stem(y);
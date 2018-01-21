amp=0.3;
fs=44100;  % sampling frequency
duration=2;
values=0:1/fs:duration;
freq=200:100/length(values):300-80/length(values);
a=amp*sin(2*pi* freq.*values)';

Fs = 1024;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 1024;             % Length of signal
t = (0:L-1)*T*6*pi;        % Time vector

% t =linspace(0,pi*2,1024); %cannot include end point!!!

x = sin(t);
X = fft(x);
plot(abs(X/L));


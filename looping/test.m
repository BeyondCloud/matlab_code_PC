% in_str = 'a_ao.wav';
% [in,Fs] = wavread(in_str);
clear;
clc;
Fs = 6000;            % Sampling frequency                    
T = 1/Fs;             % Sampling period       
L = 3000;             % Length of signal
t = (0:L-1)*T;        % Time vector
X = 0.7*cos(2*pi*300.4*t) ;
minf0 = 30;
W = ceil(Fs/minf0);
d= zeros(1,W); % d(time,lag)
for lag = 1:W
   for i=1:W  
        d(lag) = d(lag)+(X(i)-X(i+lag))^2;
   end
end

% dsum = 0;
% dcum= zeros(1, size(d,2)); % dcum 0 is always 1,won't record
% for lag =  1:size(d,2)
%     dsum = dsum+d(lag);
%     dcum(lag) = d(lag)/(dsum/(lag));
% end
dcum = diffcum(d');
plot(dcum);
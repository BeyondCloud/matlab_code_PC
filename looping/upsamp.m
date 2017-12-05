function y = upsamp(x,M,L)
%     n = 0:10239;                 % 10240 samples, 0.213 seconds long
%     Fs = 48e3;                   % Original sampling frequency-48kHz
%     x = sin(2*pi*1e3/Fs*n);      % Original signal
    [M,L] = rat(M/L);
    N = 24*L;
    h = L*fir1(N-1,1/M,kaiser(N,7.8562));
    y = upfirdn(x,h,L,M);        % 9430 samples, still 0.213 seconds

% stem(n(1:49)/Fs,x(1:49))
% hold on 
% stem(n(2:45)/(Fs*L/M),y(13:56),'*')
% hold off
% xlabel('Time (s)')
% ylabel('Signal')
% legend('Original','Resampled')
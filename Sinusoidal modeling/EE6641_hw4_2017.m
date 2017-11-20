%% EE6641 HW3: sinusoidal modeling, additive synthesis, and noise reduction
% Adapted from a Stanford EE367 lab assignment in 2002.
% Revised Apr 10, 2014
% Revised Feb 21, 2017
% Yi-Wen Liu
clear; close all;
fname = 'peaches_16';
%fname = 'mymom_16';
%fname = 'draw_16';
[x,fs] = audioread([fname '.wav']);
%x = x/max(abs(x)); 
% sound(x,fs);
nx = length(x);

%% ANALYSIS PARAMETERS
frameRate =20;  % frames per second
M = floor(fs/frameRate);  
nFrames = floor(nx/M)*2-1;
R = floor(M/2);  % Exact COLA not required
N = 2^(1+floor(log2(5*M+1))); % FFT length, at least a factor of 5 zero-padding

maxPeaks = input('how many peaks to track? '); % Default = 15
expandRatio = input('time expansion factor?'); % Default = 1.0
freqShift = input('how many semitones of pitch shift?'); % Default = 0.
fRatio = 2^(freqShift/12); 

%% VECTOR VARIABLES DECLARATION
amps = zeros(maxPeaks,nFrames);
freqs = zeros(maxPeaks,nFrames);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% ANALYSIS
%%
%w = hanning(M);
w = blackman(M);
df = fs/N;
ff = 0:df:(N-1)*df;
for m=1:nFrames
    tt = (m-1)*R+1:(m-1)*R+M;
    xw = w .* x(tt);
    Xw = fft(xw,N); % 
    [ampdB,freqindex] = MyFindpeaks(Xw(1:N/2),maxPeaks); % 
    freqsm = (freqindex-1)*pi/(N/2);
    amps(:,m) = ampdB; % amplitude is coded in dB unit
    freqs(:,m) = freqsm;
end

figure(1)
plot(freqs');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% SYNTHESIS
R = round(R* expandRatio);  % time expansion
freqs = min(pi,freqs*fRatio);
y = zeros((nFrames+1)*R,1);
state = zeros(maxPeaks,3);  % [ampInitials, freqInitials, phaseInitials] 
state(:,2) = freqs(:,m);
thresh = 10;
for m=1:nFrames-1
%% window method
%     tt = (m-1)*R+1: (m+1)*R;  
%     [y_synth,state] = MyAdditivesynth(amps(:,m),freqs(:,m),R,state);     
%% interpolation
    tt = (m-1)*R+1: m*R;        
    [y_synth,state] = MyAdditivesynth(amps(:,m),freqs(:,m),R,state,fs,thresh); 
	y(tt)= y(tt) + y_synth;
end

y = y/max(abs(y)); 
sound(y,fs);
audiowrite(sprintf('%s_SM_%d.wav',fname,maxPeaks),y,fs);


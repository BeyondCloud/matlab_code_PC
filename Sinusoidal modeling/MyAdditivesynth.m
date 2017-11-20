% Sinusoidal synthesis
% Revised Nov 2010, Yi-Wen Liu
% Revised Feb 2017 for Flipped classroom preparation.
%
% EE6641: Analysis and synthesis of audio signals
% National Tsing Hua University
% This function should take a list of the amplitude, frequency (amplitude in
% dB and frequency in rad/sample) and intial phase of sinusoidal components
% and calculate a frame of the output signal which is the sum of sinusoidal components.
%
% Synopsis:
% [y]: the output signal
% finalState:   the final state matrix, which will be used as the initial state
%               for the next frame
%
% amps: the list of amplitudes of the sinusoids (dB)
% freqs: the list of frequencies of the sinusoids (rad/sample)
% N: length of the synthesis frame (samples)
% initState: the initial state matrix

function [s,finalstate] = MyAdditivesynth(amps,freqs,R,inistate,fs,thresh)
%% Interpolation Method
finalstate(:,1)=amps;
finalstate(:,2)=freqs;
% interpolation
beta = linspace(0,1,R).';
s = zeros(R,1);
mags = 10.^(amps/20);
inimags = 10.^(inistate(:,1)/20);
inifreqs = inistate(:,2);
% phi_tmp = zeros(1,R);
% birth and death
numTracks = size(inistate,1);
key_i = log2(inifreqs/440)*12+100;
key_t = log2(freqs/440)*12+100;
M_index = 0;
for ii = 1:numTracks
    dist = 1000;
    for mm = M_index+1 : numTracks
        d = abs(key_i(ii) - key_t(mm));
        if(dist >= d)
            dist = d;
            I_index = ii;
            M_index = mm;
        end
    end
    if(dist < thresh)
        a = (1-beta)*inimags(I_index) + beta*mags(M_index);
        f = (1-beta)*inifreqs(I_index) + beta*freqs(M_index);
        %         phi_tmp = phi_tmp + 2*pi*f'*triu(ones(R))/fs;
        %         phi_t = phi_tmp';
        %         s = s+ a.*cos(phi_t(end));
        phi = 0;
        for n = 1:R
            phi = phi + f(n);
            s(n) = s(n) + a(n)*cos(phi);
        end
    end
    %     finalstate(ii,3) = phi_tmp(R);
end
%% Window Method
%% Use this double loop to synthesize a frame of the output signal
% phi = inistate(:,1)+(inistate(:,2)+freqs)/2*R;
% finalstate(:,3)=phi;
% finalstate(:,2)=freqs;
% numTracks = size(inistate,1);
% s = zeros(2*R,1);
% w=hann(2*R+1); w=w(1:end-1); % synthesis with 50% overlap using Hann (2017)
% w=w(:);
% mags = 10.^(amps/20);
% nn = 0:length(w)-1;
% nn = 0:2*R-1;
% nn = nn(:);
% for kk = 1:numTracks
%     s = s + mags(kk)*cos(freqs(kk)*nn+phi(kk));
% end
% s = s.*w;
end

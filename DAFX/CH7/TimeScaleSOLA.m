% TimeScaleSOLA.m
% Time Scaling with Synchronized Overlap and Add
%
% Parameters:
%
% analysis hop size     Sa = 256 (default parmater)		
% block length          N  = 2048 (default parameter)
% time scaling factor   0.25 <= alpha <= 2 
% overlap interval      L  = 256*alpha/2

clear all,close all

[signal,Fs]	=	wavread('x1.wav');
DAFx_in		=	signal';

Sa	=	input('Analysis hop size Sa in samples   = ');
N	=	input('Analysis block size N in samples  = ');
if Sa > N 
   disp('Sa must be less than N !!!')
end
M	=	ceil(length(DAFx_in)/Sa);

% Segmentation into blocks of length N every Sa samples
% leads to M segments

alpha =input('Time stretching factor alpha      = ');
Ss	  =round(Sa*alpha);
L	  =input('Overlap in samples (even)         = ');

if Ss >= N disp('alpha is not correct, Ss is >= N')
elseif Ss > N-L disp('alpha is not correct, Ss is > N-L')
end

DAFx_in(M*Sa+N)=0;
Overlap  =  DAFx_in(1:N);

% **** Main TimeScaleSOLA loop ****
for ni=1:M-1
  grain=DAFx_in(ni*Sa+1:N+ni*Sa);
  XCORRsegment=xcorr(grain(1:L),Overlap(1,ni*Ss:ni*Ss+(L-1)));		
  [xmax(1,ni),index(1,ni)]=max(XCORRsegment);
  fadeout=1:(-1/(length(Overlap)-(ni*Ss-(L-1)+index(1,ni)-1))):0;
  fadein=0:(1/(length(Overlap)-(ni*Ss-(L-1)+index(1,ni)-1))):1;
  Tail=Overlap(1,(ni*Ss-(L-1))+ ...
               index(1,ni)-1:length(Overlap)).*fadeout;
  Begin=grain(1:length(fadein)).*fadein;
  Add=Tail+Begin;
  Overlap=[Overlap(1,1:ni*Ss-L+index(1,ni)-1) ...
           Add grain(length(fadein)+1:N)];
end;
% **** end TimeScaleSOLA loop ****
% Output in WAV file
sound(Overlap,44100);
wavwrite(Overlap,Fs,'x1_time_stretch');	
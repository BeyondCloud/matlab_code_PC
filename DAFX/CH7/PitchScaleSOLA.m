% PitchScaleSOLA.m
% Parameters:
%    analysis hop size     Sa = 256 (default parmater)		
%    block length          N  = 2048 (default parameter)
%    pitch scaling factor  0.25 <= alpha <= 2 
%    overlap interval      L  = 256*alpha/2
clear all,close all
[signal,Fs]	=	audioread('x3.wav');
DAFx_in		=	signal';

Sa=256;
N=2048;	          % time scaling parameters
M=ceil(length(DAFx_in)/Sa);

n1=512;
n2=256;            % pitch scaling n1/n2
Ss=round(Sa*n1/n2);
L=256*(n1/n2)/2;

DAFx_in(M*Sa+N)=0;
Overlap=DAFx_in(1:N);

% ****** Time Stretching with alpha=n2/n1******
% **** Main TimeScaleSOLA loop ****
for ni=1:M-1
  grain=DAFx_in(ni*Sa+1:ni*Sa+N);
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
% ****** End Time Stretching ******

% ****** Pitch shifting with alpha=n1/n2 ******
lfen=2048;lfen2=lfen/2;
w1=hanningz(lfen);w2=w1;

% for linear interpolation of a grain of length lx to length lfen
lx=floor(lfen*n1/n2);
x=1+(0:lfen-1)'*lx/lfen;
ix=floor(x);ix1=ix+1;
dx=x-ix;
dx1=1-dx;
%
lmax=max(lfen,lx);
Overlap=Overlap';
DAFx_out=zeros(length(DAFx_in),1);

pin=0;pout=0;
pend=length(Overlap)-lmax;
%  Pitch shifting by resampling a grain of length lx to length lfen
while pin<pend
  grain2=(Overlap(pin+ix).*dx1+Overlap(pin+ix1).*dx).* w1; 
  DAFx_out(pout+1:pout+lfen)=DAFx_out(pout+1:pout+lfen)+grain2;
  pin=pin+n1;pout=pout+n2;
end;
% Output in WAV file
DAFx_out = 0.5*DAFx_out/max(DAFx_out);
sound(DAFx_out*0.5,44100);
audiowrite('x2_pitch_stretch.wav',DAFx_out,Fs);
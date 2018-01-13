% granulation.m
f=fopen('a_male.m11');
x=fread(f,'int16')';
fclose(f);

Ly=length(x);  y=zeros(1,Ly);              %output signal
% Constants
nEv=4; maxL=200;  minL=50;  Lw=20;
% Initializations
L = round((maxL-minL)*rand(1,nEv))+minL;   %grain length
initIn = ceil((Ly-maxL)*rand(1,nEv));      %init grain
initOut= ceil((Ly-maxL)*rand(1,nEv));      %init out grain
a = rand(1,nEv);                           %ampl. grain
endOut=initOut+L-1;
% Synthesis
for k=1:nEv,
  grain=grainLn(x,initIn(k),L(k),Lw);
  y(initOut(k):endOut(k))=y(initOut(k):endOut(k))+a(k)*grain;
end
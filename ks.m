%Karplus-Strong model
%   ks(f,length) 
%   f=frequency
%   length=time (seconds)
fs=44100;
f=261;
length = 1;
N=fix(fs/f);
% create zeros matrix(rows,cols)
X=zeros(1,length*fs);
%loop filter
%        z^-N               
b1=[zeros(1,N) 1];
%       1 - H(z)z^-N
%a moving average filter
a1=[1 zeros(1,N-1) -.5 -.5];
% Initial conditions for filter delays
Zi = rand(1, max(max(size(a1)), max(size(b1) ) )-1 );
% filter (x coeff,y coeff,
%input data=0 in this case,filter initial input)
Y=filter(b1,a1,X,Zi);
subplot(2,1,1);
plot(Zi);
subplot(2,1,2);
plot(Y);
sound (Y,44100);

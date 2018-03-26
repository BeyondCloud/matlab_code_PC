[x fs] = audioread('a.wav');
x = x(4000:end);
frames = floor(88200/1024);
N = 1024;
X = zeros(N,frames);
for i = 1:frames
    X(:,i) = fft(x(i*1024-1023:i*1024));
end
Xa = angle(X)/pi*180;
Xabs = abs(X);

z = (0:2:(N*2-2))*pi/N;
z = complex(cos(z),sin(z));
Xz =Xabs;
Xz(:,1) = 1;
for f  = 2:frames
    Xz(:,f) =z;
    z = z.*z./abs(z);
end
Xabs = Xabs.*Xz;
nx = Xabs;
for i = 1:frames
    nx(:,i) = ifft(Xabs(:,i));
end
nx = real(nx);
nx  = reshape(nx,[],1);

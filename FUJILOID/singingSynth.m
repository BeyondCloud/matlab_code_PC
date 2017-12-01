%overshoot
w1=0.0348, zeta1=0.5422,k1= 0.0348;
%vibrato (0.0345, 0, 0.0018)
w2=0.0345, zeta2=0,k2= 0.0018;
%preparation d (0.0292, 0.6681, 0.0292)
w3=0.0292, zeta3=0.6681,k3= 0.0292;
w = [w1 w2 w3];
zeta = [zeta1 zeta2 zeta3];
k = [k1 k2 k3];

N=3000;
fs = 0.001;
H = tf(k(2),[1, 2*zeta(2)*w(2) ,w(2)^2],fs);
x = zeros(1,N);
x(:,1:N/3)=508;
x(:,N/3:N*2/3)=600;
x(:,N*2/3:N)=640;

[y,t]=lsim(H,x);
plot(t,y);


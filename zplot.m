L=1000;
dw=2*pi/L;
w = -pi:dw:pi-dw;
aa=[1,0.6804,0.953486,0.182128];
bb=[0.2031,-0.2588,0.2588,-0.2031];
HH=freqz(bb,aa,w);
mag=abs(HH);title('Magnitude response')
figure
phase=angle(HH);title('Phase response')
plot(w,mag)
plot(w,phase)
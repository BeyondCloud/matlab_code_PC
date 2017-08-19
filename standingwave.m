function[]=standingwave()
clc;
z=linspace(-4*pi,4*pi,1000);
i=0;
j=0.25
for k=0:257
   fr = 2*cos(i*pi -z) +2*cos(i*pi +z) ;
   bk = cos(i*pi+z+pi*j);
   y=fr+bk;
   plot(z,fr,'r',z,bk,'g',z,y,'b');
   axis([-4*pi 0 -4 4]);
   ax = gca;
   ax.Xtick = [-3*pi -2*pi -pi 0 pi 2*pi 3*pi];
   grid on;
   pause(0.1);
   i=i+2*0.0078125;

end